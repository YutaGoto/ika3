# frozen_string_literal: true

RSpec.describe Ika3::Schedule do
  let(:schedule) { described_class.new(contact_info) }
  let(:contact_info) { '@YutaGoto_rspec' }

  describe 'regular_battle' do
    let!(:stub_connection) do
      Faraday.new do |conn|
        conn.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get('/api/regular/now') do
            [200, {}, JSON.generate(success_response)]
          end
        end
      end
    end

    let(:success_response) do
      { results: [{ start_time: '2024-05-17T13:00:00+09:00', end_time: '2024-05-17T15:00:00+09:00', rule: { key: 'TURF_WAR', name: 'ナワバリバトル' }, stages: [{ id: 5, name: 'ナンプラー遺跡', image: 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/f14c2a64e49d243679fc0884af91e1a07dc65600f9b90aefe92d7790dcffb191_1.png?Expires=1736467200&Signature=Gy0f5Uk0h4SloLBrLprURsWPUrX0hcGLd319mIA5W9-R22eyrzMP1IwXMMtSNNrCRtBQWj86jIOO7qChcH~W3QL7gj66zhX6cw-HLC6PMUnF71KlkumQa1jgg7F6pVDkaq4lIxZuI3jM4DYoSZet6foHgrQwzULfc0bh6Voa41x83En6F~Hybs9gDehxTbD6it6uO6f-0C5j6hGvr3IoFvv9q-Gsu0bsd5xKSjnT~Fx32IL~CXzcl46wBr5wGJ3KMXQ~CFZa3hBysJvj-yA31TMs8eokxfxghPPH2eQ8SnxGkbSoUhIyrvDGALRjYQDbX7K0sObsa7WGYHXWwK95tQ__&Key-Pair-Id=KNBS2THMRC385' }, { id: 13, name: '海女美術大学', image: 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/40aba8b36a9439e2d670fde5b3478819ea8a94f9e503b9d783248a5716786f35_1.png?Expires=1736467200&Signature=fCAlEq7s7tze408rj4uhd2IqQHDdz19Oz1ay1bfGRv2mhtjLLNDy2MUtjcA3I9l1IxBzc44TUx27nxmI3LfRL~jc0jFBf5qYcMCFFp51Bvx977SZCKk0MLAcFo8Y23gEaA-3waXhng1aIRfdp17sXeG1BBjOpec1aJ38bdi0N10ZKgOL8464VE5mWnGl7dKodhMfmar~bXvg-qKjRgtj3IuZMamalItWAbQV~2HIYAWXUuikPyAOE-oMvUOH7sDfcH-leQYpI6Nx9naKTDWgEFjGfBZVYkWGgHmk6MpcZZEqW9YMMpxrBdNmGGaLq7ZJylh9O1wc~1I7TUCW-xl4mQ__&Key-Pair-Id=KNBS2THMRC385' }], is_fest: false }] }
    end

    before do
      allow(Faraday).to receive(:connection).and_return(stub_connection)
    end

    describe '#regular_now' do
      it 'get current regular match' do
        expect(schedule.regular_now.start_time).not_to be_nil
        expect(schedule.regular_now.stages.count).to be(2)
      end
    end
  end

  describe '#bankara_open_next' do
    it 'get next bankara open match' do
      expect(schedule.bankara_open_next.start_time).not_to be_nil
      expect(schedule.bankara_open_next.stages.count).to be(2)
    end
  end

  describe '#bankara_challenge_next' do
    it 'get next bankara challenge match' do
      expect(schedule.bankara_challenge_next.start_time).not_to be_nil
      expect(schedule.bankara_challenge_next.stages.count).to be(2)
    end
  end

  describe '#x_now' do
    it 'get current x match' do
      expect(schedule.x_now.start_time).not_to be_nil
      expect(schedule.x_now.stages.count).to be(2)
    end
  end

  describe '#fest_now' do
    let(:fest) { schedule.fest_now.is_fest }

    it 'get current fest match' do
      expect(schedule.fest_now.start_time).not_to be_nil
      if fest
        expect(schedule.fest_now.stages.count).to be(stages_count)
      else
        expect(schedule.fest_now.stages).to be_nil
      end
    end
  end

  describe '#salmon_run_now' do
    it 'get current salmon run' do
      expect(schedule.salmon_run_now.start_time).not_to be_nil
      expect(schedule.salmon_run_now.weapons.count).to be(4)
    end
  end

  describe '#salmon_run_team_contest' do
    it 'get current salmon run team contest' do
      expect(schedule.salmon_run_team_contest.stage).to be_nil
    end
  end
end
