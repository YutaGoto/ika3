require 'octokit'
require 'json'
require 'faraday'

# --- 環境変数の設定 ---
GEMINI_API_KEY = ENV.fetch('GEMINI_API_KEY', nil)
PR_TITLE = ENV.fetch('PR_TITLE', nil)
PR_BODY = ENV.fetch('PR_BODY', nil)
PR_NUMBER = ENV.fetch('PR_NUMBER', nil)
PR_REPO = ENV.fetch('PR_REPO', nil)
GITHUB_TOKEN = ENV.fetch('GITHUB_TOKEN', nil)

def extract_gem_info(pr_title)
  match = pr_title.match(/Bump ([\w-]+) from ([\d.]+) to ([\d.]+)/)
  return nil unless match

  { name: match[1], old_version: match[2], new_version: match[3] }
end

def fetch_gem_repo_url(gem_name)
  response = Faraday.get("https://rubygems.org/api/v1/gems/#{gem_name}.json")
  return nil unless response.status == 200

  data = JSON.parse(response.body)
  data['source_code_uri'] || data['homepage_uri']
end

def fetch_release_notes(repo_url, new_version)
  begin
    host = URI.parse(repo_url).host
  rescue URI::InvalidURIError
    return 'リリースノートが見つかりませんでした。'
  end
  return 'リリースノートが見つかりませんでした。' unless host == 'github.com'

  repo_path = URI.parse(repo_url).path.sub(%r{^/}, '')
  client = Octokit::Client.new(access_token: GITHUB_TOKEN)

  begin
    release = client.releases(repo_path).find { |r| ["v#{new_version}", new_version].include?(r.tag_name) }
    return release.body if release
  rescue Octokit::NotFound
    return 'リリースが見つかりません。CHANGELOGを確認してください。'
  end
  'リリースノートが見つかりませんでした。'
end

def get_gemini_summary(text)
  conn = Faraday.new(
    url: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=#{GEMINI_API_KEY}",
    headers: { 'Content-Type' => 'application/json' }
  )

  prompt = "以下のRuby gemのリリースノートを日本語で簡潔に要約してください。\n\n#{text}"
  payload = {
    contents: [{
      parts: [{ text: prompt }]
    }],
    generationConfig: {
      thinkingConfig: {
        thinkingBudget: 0
      }
    }
  }

  response = conn.post('', payload.to_json)
  return '要約できませんでした。' unless response.success?

  result = JSON.parse(response.body)
  begin
    result['candidates'][0]['content']['parts'][0]['text']
  rescue StandardError
    '要約できませんでした。'
  end
end

# --- メイン処理 ---
begin
  gem_info = extract_gem_info(PR_TITLE)
  raise 'Gem information could not be extracted.' unless gem_info

  repo_url = fetch_gem_repo_url(gem_info[:name])
  repo_url = repo_url&.sub(%r{/$}, '')
  release_notes = fetch_release_notes(repo_url, gem_info[:new_version])

  # --- 各種情報の準備 ---
  summary = get_gemini_summary(release_notes)

  # セマンティックバージョニングによる破壊的変更の検出
  is_major_version_update = gem_info[:new_version].split('.')[0] != gem_info[:old_version].split('.')[0]
  breaking_changes_note = is_major_version_update ? '⚠️ メジャーバージョンアップのため、破壊的変更が含まれている可能性があります。' : '破壊的変更は含まれていないようです。'

  # セキュリティ修正のチェック (簡易版)
  has_security_fix = PR_TITLE.downcase.include?('security') || PR_BODY.downcase.include?('cve-')
  security_note = has_security_fix ? '✅ セキュリティ修正が含まれています。' : 'セキュリティ修正は含まれていないようです。'

  # --- コメントの投稿 ---
  client = Octokit::Client.new(access_token: GITHUB_TOKEN)
  comment_body = <<~MARKDOWN
    ## Dependabot PR サマリー ✨

    ### リリースノートの要約
    #{summary}

    ### 破壊的変更の可能性
    #{breaking_changes_note}

    ### セキュリティ修正の有無
    #{security_note}

    ---
    *このコメントは、GitHub ActionsとGemini APIによって自動生成されました。*
  MARKDOWN

  puts comment_body

  client.add_comment(PR_REPO, PR_NUMBER.to_i, comment_body)
rescue StandardError => e
  puts "An error occurred: #{e.message}"
  exit 1
end
