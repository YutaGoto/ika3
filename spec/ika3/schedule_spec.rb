# frozen_string_literal: true

RSpec.describe Ika3::Schedule do
  let(:schedule) { described_class.new(contact_info) }
  let(:contact_info) { '@YutaGoto_rspec' }

  let!(:stub_connection) do
    Faraday.new do |conn|
      conn.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/api/regular/now') do
          [200, {}, success_response]
        end

        stub.get('/api/bankara-open/next') do
          [200, {}, success_response]
        end

        stub.get('/api/bankara-challenge/next') do
          [200, {}, success_response]
        end

        stub.get('/api/x/now') do
          [200, {}, success_response]
        end

        stub.get('/api/fest/next') do
          [200, {}, success_response]
        end

        stub.get('/api/fest-challenge/now') do
          [200, {}, success_response]
        end

        stub.get('/api/coop-grouping/now') do
          [200, {}, success_response]
        end

        stub.get('/api/coop-grouping-team-contest/schedule') do
          [200, {}, success_response]
        end
      end
    end
  end

  describe 'regular_battle' do
    let(:success_response) do
      { 'results' => [{ 'start_time' => '2024-05-17T13:00:00+09:00', 'end_time' => '2024-05-17T15:00:00+09:00', 'rule' => { 'key' => 'TURF_WAR', 'name' => 'ナワバリバトル' }, 'stages' => [{ 'id' => 5, 'name' => 'ナンプラー遺跡', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/f14c2a64e49d243679fc0884af91e1a07dc65600f9b90aefe92d7790dcffb191_1.png?Expires=1736467200&Signature=Gy0f5Uk0h4SloLBrLprURsWPUrX0hcGLd319mIA5W9-R22eyrzMP1IwXMMtSNNrCRtBQWj86jIOO7qChcH~W3QL7gj66zhX6cw-HLC6PMUnF71KlkumQa1jgg7F6pVDkaq4lIxZuI3jM4DYoSZet6foHgrQwzULfc0bh6Voa41x83En6F~Hybs9gDehxTbD6it6uO6f-0C5j6hGvr3IoFvv9q-Gsu0bsd5xKSjnT~Fx32IL~CXzcl46wBr5wGJ3KMXQ~CFZa3hBysJvj-yA31TMs8eokxfxghPPH2eQ8SnxGkbSoUhIyrvDGALRjYQDbX7K0sObsa7WGYHXWwK95tQ__&Key-Pair-Id=KNBS2THMRC385' }, { 'id' => 13, 'name' => '海女美術大学', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/40aba8b36a9439e2d670fde5b3478819ea8a94f9e503b9d783248a5716786f35_1.png?Expires=1736467200&Signature=fCAlEq7s7tze408rj4uhd2IqQHDdz19Oz1ay1bfGRv2mhtjLLNDy2MUtjcA3I9l1IxBzc44TUx27nxmI3LfRL~jc0jFBf5qYcMCFFp51Bvx977SZCKk0MLAcFo8Y23gEaA-3waXhng1aIRfdp17sXeG1BBjOpec1aJ38bdi0N10ZKgOL8464VE5mWnGl7dKodhMfmar~bXvg-qKjRgtj3IuZMamalItWAbQV~2HIYAWXUuikPyAOE-oMvUOH7sDfcH-leQYpI6Nx9naKTDWgEFjGfBZVYkWGgHmk6MpcZZEqW9YMMpxrBdNmGGaLq7ZJylh9O1wc~1I7TUCW-xl4mQ__&Key-Pair-Id=KNBS2THMRC385' }], 'is_fest' => false }] }
    end

    before do
      allow(Faraday).to receive(:new).and_return(stub_connection)
    end

    describe '#regular_now' do
      it 'get current regular match' do
        expect(schedule.regular_now.start_time).not_to be_nil
        expect(schedule.regular_now.stages.count).to be(2)
      end
    end
  end

  describe '#bankara_open_next' do
    let(:success_response) do
      { 'results' => [{ 'start_time' => '2024-05-28T23:00:00+09:00', 'end_time' => '2024-05-29T01:00:00+09:00', 'rule' => { 'key' => 'LOFT', 'name' => 'ガチヤグラ' }, 'stages' => [{ 'id' => 2, 'name' => 'ゴンズイ地区', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/898e1ae6c737a9d44552c7c81f9b710676492681525c514eadc68a6780aa52af_1.png?Expires=1736467200&Signature=trWaSROzlG2pyF45WyFe1HwVsWsASGV7tCdhbNGUjnOYGhk2Uvn2lvy8jK8tTM7w0pZpfeJMbLZcs0SuVfemWsxLnGhu3IFWnZPXgVEZH5efA3G54UYcfDJGbEHlllnqkygFHIQ6aJgSJ0bcbggHYzBLjgbEkXWnxGuoYZKY0P-n~NDFJ8HgjIlFJw-zaCelo791mzeL7BE-Z65rJzawr56cAsrPkxRyb3qmbg0stuAMwTMEVJ48jxWNZyl87stzE22geRiWf4s6FHlYdMgiQrmog5R7dyXx6cAvJqgMi17~E6NaDA8Dbnyk6gLTNTMLOAimiyfewU8MYpJrvBt0xw__&Key-Pair-Id=KNBS2THMRC385' }, { 'id' => 9, 'name' => 'ヒラメが丘団地', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/488017f3ce712fca9fb37d61fe306343054449bb2d2bb1751d95f54a98564cae_1.png?Expires=1736467200&Signature=DG7hRTWAvNvGK71TCw3fbEXVbIlOdD39BitQuF6eWxF-dX7h10HxUnkY2p4ETsef8AKAHDGGZR8iDskWXsa-FNoQuTySGDaZBhZhtcKEmFT~zwo7id3XM4brtLsPvEtlI1cApOxijHVJzxrBNh5r9whUzHoq2jnMDAntRFg7nGopVecfMDsGW9YzBDZd7LMegcaa6t~R~JohUVCl2vE36JvxZLsJjgqsaZZxRsq40m1dMI4rXF98tkGWMzCMDpqb9Mf7kgnB~yMOSRs0XjadBDpU9~w~2dH7AKxvrNBKKXouMfDdUWN7BDHTqS21HUfFoR4hwkhqAvl2yxRKzsmT6w__&Key-Pair-Id=KNBS2THMRC385' }], 'is_fest' => false }] }
    end

    before do
      allow(Faraday).to receive(:new).and_return(stub_connection)
    end

    it 'get next bankara open match' do
      expect(schedule.bankara_open_next.start_time).not_to be_nil
      expect(schedule.bankara_open_next.stages.count).to be(2)
    end
  end

  describe '#bankara_challenge_next' do
    let(:success_response) do
      { 'results' => [{ 'start_time' => '2024-05-28T23:00:00+09:00', 'end_time' => '2024-05-29T01:00:00+09:00', 'rule' => { 'key' => 'LOFT', 'name' => 'ガチヤグラ' }, 'stages' => [{ 'id' => 2, 'name' => 'ゴンズイ地区', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/898e1ae6c737a9d44552c7c81f9b710676492681525c514eadc68a6780aa52af_1.png?Expires=1736467200&Signature=trWaSROzlG2pyF45WyFe1HwVsWsASGV7tCdhbNGUjnOYGhk2Uvn2lvy8jK8tTM7w0pZpfeJMbLZcs0SuVfemWsxLnGhu3IFWnZPXgVEZH5efA3G54UYcfDJGbEHlllnqkygFHIQ6aJgSJ0bcbggHYzBLjgbEkXWnxGuoYZKY0P-n~NDFJ8HgjIlFJw-zaCelo791mzeL7BE-Z65rJzawr56cAsrPkxRyb3qmbg0stuAMwTMEVJ48jxWNZyl87stzE22geRiWf4s6FHlYdMgiQrmog5R7dyXx6cAvJqgMi17~E6NaDA8Dbnyk6gLTNTMLOAimiyfewU8MYpJrvBt0xw__&Key-Pair-Id=KNBS2THMRC385' }, { 'id' => 9, 'name' => 'ヒラメが丘団地', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/488017f3ce712fca9fb37d61fe306343054449bb2d2bb1751d95f54a98564cae_1.png?Expires=1736467200&Signature=DG7hRTWAvNvGK71TCw3fbEXVbIlOdD39BitQuF6eWxF-dX7h10HxUnkY2p4ETsef8AKAHDGGZR8iDskWXsa-FNoQuTySGDaZBhZhtcKEmFT~zwo7id3XM4brtLsPvEtlI1cApOxijHVJzxrBNh5r9whUzHoq2jnMDAntRFg7nGopVecfMDsGW9YzBDZd7LMegcaa6t~R~JohUVCl2vE36JvxZLsJjgqsaZZxRsq40m1dMI4rXF98tkGWMzCMDpqb9Mf7kgnB~yMOSRs0XjadBDpU9~w~2dH7AKxvrNBKKXouMfDdUWN7BDHTqS21HUfFoR4hwkhqAvl2yxRKzsmT6w__&Key-Pair-Id=KNBS2THMRC385' }], 'is_fest' => false }] }
    end

    before do
      allow(Faraday).to receive(:new).and_return(stub_connection)
    end

    it 'get next bankara challenge match' do
      expect(schedule.bankara_challenge_next.start_time).not_to be_nil
      expect(schedule.bankara_challenge_next.stages.count).to be(2)
    end
  end

  describe '#x_now' do
    let(:success_response) do
      { 'results' => [{ 'start_time' => '2024-05-28T21:00:00+09:00', 'end_time' => '2024-05-28T23:00:00+09:00', 'rule' => { 'key' => 'LOFT', 'name' => 'ガチヤグラ' }, 'stages' => [{ 'id' => 1, 'name' => 'ユノハナ大渓谷', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/35f9ca08ccc2bf759774ab2cb886567c117b9287875ca92fb590c1294ddcdc1e_1.png?Expires=1736467200&Signature=PyizfYLfdNYKJqzYcMxhH4vzPOWZPlpQQoLFIiByt2g2Z5bqKPkmArXfJD2J550kGLoL339SG~XuIoXRHn9SwP9WCa~-rWvlX216RZM5COnb00NhPBcaW3hzxqTDd00wLRJZewYDgBuhnXq7ceWLCTuW51y2K2J-S-sB2xd6Tr2gwm3noU4YRKQ1kDuHn5osYeWQS48fKVnjgenifMI~EFVM8CHX~3uNZ~du9yrVbiVklMQc5wTlGoRbG4fQ1WHiMnog4h0~O4M-I2QqEGZLjyt3uLIRA6UU7XV-RhEk5CP7HFA8Cm7Yy5-E7dsWBT4oIl5WXke7PUx~u2w-J4I2SA__&Key-Pair-Id=KNBS2THMRC385' }, { 'id' => 6, 'name' => 'ナメロウ金属', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/de1f212e9ff0648f36cd3b8e0917ef36b3bd51445159297dcb948f34a09f2f05_1.png?Expires=1736467200&Signature=HvcUQoWZ0-7dH5eVwmdAyt-YCXeJj9yR7oZaFu3kkdr4X4nV92XCgkMHW7390Pbs6Beoc650LCQIVUf7rHvgiXL0CEopn1NiuazZib75XFuITzPbongK6pkhBOlDfa3uEi1M~BqEfOL5cFHgTRhV9wZJncQjxWJ6HQMz9wAXTrCxqVxz1loK1sdE~g3FpaieYlGXztX2VnAG1Eswtu3-DzwT8ELJv-iXgbulJ24GUak-p2ajDpyl2xvLAeSCr0CXmjSI3gXEZJxpREfDjLlwkEAPzGQqhIl9k9lbs1Wf9kV7p~pS0d3neOPRnz2lQ9Bhl4zguAXCrTwFSaJYsZthXA__&Key-Pair-Id=KNBS2THMRC385' }], 'is_fest' => false }] }
    end

    before do
      allow(Faraday).to receive(:new).and_return(stub_connection)
    end

    it 'get current x match' do
      expect(schedule.x_now.start_time).not_to be_nil
      expect(schedule.x_now.stages.count).to be(2)
    end
  end

  describe '#fest_challenge_now' do
    context 'when not opening fest challenge' do
      let(:success_response) do
        { 'results' => [{ 'start_time' => '2024-08-10T21:00:00+09:00', 'end_time' => '2024-08-10T23:00:00+09:00', 'rule' => { 'key' => 'TURF_WAR', 'name' => 'ナワバリバトル' }, 'stages' => [{ 'id' => 11, 'name' => 'キンメダイ美術館', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/b9d8cfa186d197a27e075600a107c99d9e21646d116730f0843e0fff0aaba7dd_1.png?Expires=1736467200&Signature=BWCy8LEUAf8JPkCFoWoKgXAYZQVnGJISByFHNrcHmz0~JKB~h-ZokERpG~UuUDx7zkWwArV47~PVhWaQISURZ9rMrTYVMuJ~~TL0dBR5gJYP4zdGsGBB4KsH2GIfnk5PueiCGYIy3Mri4PoyTNCg-CyRVaW-nGQXqghD1-BW2xc9918ro7kM-EEvkVYAyvk7B~K910z8mmEP0SZTnI0Z546IBV71qQ3tcex0QYvLulqfuSjOugGd5HrsD1CHLQURSGlvyFmRbPEWjzwImubbf5SiaDpTMwh9jV4ow3RbUia76ynzyn325aXJI5iTM~Lj1Xl9~FEInOK-X4mBRKeNKg__&Key-Pair-Id=KNBS2THMRC385' }, { 'id' => 17, 'name' => 'コンブトラック', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/7b3cf118bd9f45d141cd6db0ee75b06e697fa83945c7fe1e6f8483de6a591f5f_1.png?Expires=1736467200&Signature=VcFhGtCf~KlHgukh~YvktaujxYVpqjl-OgBd~c~hvWDQtzQTWsZJHdtY9L15x0Kq~4Yt5lkAbu8Y4h8jt~OQ75eRXTDkpyxKqD8e7yq~V1EXflUirec0xWrneRjtjtEmOwbiB7agezdL5oUQWJV3d3I5evYhAldBCXi7zVx9Yrm37TUgnN4rIhnCHWEDoSNTj9kFI8mPImAgK8b2Qzr84iin~BA7F9t~hLQ8IuvWuHzoKnQ1WttOraJkOvUvI39M6yqpBEDFXhkDahf92Ek7thcVAdsiY0bZDCXIOQSjx1Cw25IN5TuRq~c6V-NjJ1yCYz4KpLdteGwrc4yxsrLMIw__&Key-Pair-Id=KNBS2THMRC385' }], 'is_fest' => true, 'is_tricolor' => false, 'tricolor_stage' => nil }] }
      end

      before do
        allow(Faraday).to receive(:new).and_return(stub_connection)
      end

      it 'get current fest match' do
        expect(schedule.fest_challenge_now.start_time).not_to be_nil
        expect(schedule.fest_challenge_now.stages.count).to be(2)
        expect(schedule.fest_challenge_now.is_tricolor).to be_falsey
      end
    end
  end

  describe '#fest_next' do
    context 'when opening tricolor battle' do
      let(:success_response) do
        { 'results' => [{ 'start_time' => '2024-08-11T13:00:00+09:00', 'end_time' => '2024-08-11T15:00:00+09:00', 'rule' => { 'key' => 'TURF_WAR', 'name' => 'ナワバリバトル' }, 'stages' => [{ 'id' => 8, 'name' => 'タラポートショッピングパーク', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/f70e9f5af477a39ccfab631bfb81c9e2cedb4cd0947fe260847c214a6d23695f_1.png?Expires=1736467200&Signature=Af8Njk91CeBCbzDcfTB~8t8KGzDYlkqoTMVg5KERUqmeym6VgvStPubSXeQzen~kO0Qk9JHb35-AVEARVS0-HH8HyxX7Xo3fJ3wb~FdBxP7Us7GRZU2TW029XZqR7bOg78WBdEo-Y2URpB6yZGyMIrASC1lGDDzEjXGHpgTK0ToYVp1WxJRUuSomEfIMQsPLKHNimTJUVDbsz3zcoCisgvPUZYJBrmGdu-uxt6X2r0DicG72dG4SIGwW30GwqD9l-ev8dKWt8bsoT~d2H5zhu2k16xqTKfm0mEjedUNcesusZtaZhhlra-1bUaNW0HTbNUVF~z10gq9EDplYdswBjg__&Key-Pair-Id=KNBS2THMRC385' }, { 'id' => 10, 'name' => 'マサバ海峡大橋', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/1db8ab338b64b464df50e7f9e270e59423ff8caac6f09679a24f1b7acf3a82f3_1.png?Expires=1736467200&Signature=M10UmX5dEESMSiX6UP6pt1652485EFFnLPgAv46k06cITKu7S2YQBnj1t8qlZ72lKF8~guYnN2Tg5ogcvIcXcm-94H8nIvNfQocbFg754XMs8TNYp853Vx~YCoR6h0zlRafc~Ougdki~fb8pUwbx5ze9KxwFi1CU4Jd2QWzx3cLCNKZFc7-eabvXOS0fxw~S~sKfysnngcvSN82SHztb2AifB0Kx64i8IJ-8T8P6mi99ytWogLvTSa0H1qRCi3z9giA4Pg9xHVEiNyrt4BSQheFkNN7rm7H-TrsF1A4E03tY7Ytjj9fyXmDEEMI1Ty1EWGArZ4-7BH0ZAQn-3Pubhg__&Key-Pair-Id=KNBS2THMRC385' }], 'is_fest' => true, 'is_tricolor' => true, 'tricolor_stage' => { 'name' => 'ゴンズイ地区', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/high_resolution/898e1ae6c737a9d44552c7c81f9b710676492681525c514eadc68a6780aa52af_0.png?Expires=1736467200&Signature=kxImC-5ODLafZSXW0JwKzMhmUYvG24ZBUwVVp0emJa8FxnFEREnpy9CyZYSGhJt0zuHPvwXXWFzQNpV2~Y-h-cX9bdbeGhXPVIP7Y7CA-O2NMtPIq-4PG4-TTreoJtzGHfGa3ppCd9jOOrx17g0ij3~JDYI~WsEYHpi9B0srv9CdZSZ1FOfHzbiUDyDtEtmMZ~aLgwavOt2jUVDzY4L9s5p1ZAz-dgAgv4CI19cyhmisI7PHZNG1ndF1nprHWsJnZ6M3ei4MVgbA011ajjUQRd~rcWjr~jANARLacDvN9mr~15hRdvujzsNmmANAQMG7hdMp3DaQSKVDqlbns3MTVg__&Key-Pair-Id=KNBS2THMRC385' } }] }
      end

      before do
        allow(Faraday).to receive(:new).and_return(stub_connection)
      end

      it 'get next fest tricolor match' do
        expect(schedule.fest_next.start_time).not_to be_nil
        expect(schedule.fest_next.stages.count).to be(2)
        expect(schedule.fest_next.tricolor_stage.name).not_to be_nil
      end
    end
  end

  describe '#salmon_run_now' do
    let(:success_response) do
      { 'results' => [{ 'start_time' => '2024-05-28T17:00:00+09:00', 'end_time' => '2024-05-30T09:00:00+09:00', 'boss' => { 'id' => 'Q29vcEVuZW15LTI0', 'name' => 'タツ' }, 'stage' => { 'id' => 0, 'name' => 'ムニ・エール海洋発電所', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/high_resolution/f1e4df4cff1dc5e0acc66a9654fecf949224f7e4f6bd36305d4600ac3fa3db7b_0.png?Expires=1736467200&Signature=ELdkRzxxs7HvcI5JDkGn~cLNsel2ZxGetFsQIp9KNO8iagucQluzcJ~tYCXFcpIMB5z9badkgrBcv75CKdQLlmKff~s617ono0nTXTB2XvTRpBLqPifn3AHB8kLKGQEdI9hJuEiG9e88A6JbB4KLpP8E9XWu~7EjNPlYq--CiN~UiSIVrK~4pIL1-42ppjik2~RPbyCMITq2qsIu~LUGIOR2aor2oufClz1TEOf33qvH-C2RlUqa64nqtOi~c0k6PGjmdHb-R4hWAxv2VWjGRcrdKrAq9juqtW4fOoI9BCYQdHW4RRTlijsuCTiXeEpZX6DzwF3mRk1jExqVBv0uzw__&Key-Pair-Id=KNBS2THMRC385' }, 'weapons' => [{ 'name' => 'プロモデラーMG', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/weapon_illust/5ec00bcf96c7a3f731d7a2e67f60f802f33d22f07177b94d5905f471b08b629f_0.png?Expires=1736467200&Signature=Grf8A20qLmtWXzxWWHU7jt7b7uLbiq4-9wyqCoDNHA0GWfr3Uvx~cQJlt~ogG9ifNoaElE8o0PLkNlerDDffRUQ7FsgMvINoQ2RMQ~LIEkpgAPZmyRbBn5gZLj~9LZnfKsziWkSQhOp~OAnRIBKlJHNc~sTwThe6Timh~EOpzck8DaQcHM39OxIVHG4cdzX4Rbq9Grspzf4BXm~V~jqUcgo~LyCyHgfvsKNK7T7pTjK7XxmSIxwkz0Na72rgcQC44FqLstL9vS8MyuLAP1CuawfrGuJB94AXLtzwwhTuwYByfzRbc9GJ-gWKXlWPEe5jYe8AO0zIq0vgaW12Ji~aJg__&Key-Pair-Id=KNBS2THMRC385' }, { 'name' => 'ヴァリアブルローラー', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/weapon_illust/8351e99589f03f49b5d681d36b083aaffd9c486a0558ab957ac44b0db0bb58bb_0.png?Expires=1736467200&Signature=dV7st5IDhppQ00ZJzzFH8E0JLHvFtyg3eVLHU1vu7XdPG3I7gvEtI9U5eEF~Qi1CGTW3hJfbHKbKFfYTEnMYXqx7rF2wcg~CBedLXotDQ5DQudUrKSY1TCZ9WIFgh1Zcn2Hi63STrLz3kVfZtBBst-C~P09723H4Tbl9mqZ8F~3nYpBKVDPCuxPtdV6-p2wDYgEQUb9yxrT~xkae5cd4eOCTSa50JxnIj7KaBSn9cEU6ct3KRHeLYXnqhGjxjDZiGB65CJN8yegicMCrsfVeHvkRhANeXbBbk2-0gSYSRhT6ZL8gzHkaMDET8yOxtKEGDGbbcQvO00cQcYr3dlbb0g__&Key-Pair-Id=KNBS2THMRC385' }, { 'name' => 'クーゲルシュライバー', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/weapon_illust/206dbf3b5dfc9962b6a783acf68a856f0c8fbf0c56257c2ca5c25d63198dd6e1_0.png?Expires=1736467200&Signature=DEmcysSeO0mcWL1ZOKqW3BelB7LkLIYy8chxdLL3fb~ilQxbiQJR8DmsSN62aNO4kSIzAM0Qx9aJUua07gufVCMyQGDAxfsN-FxOyRVXcVcS2WkFXFqJDujXfoS07dX6KOmKFTot~2vfzI2vW~k~cG-x74NYe4Ly~irdKcsLSPMgkq--ltcWt6HGlbu3FsBT2~rfaCbcCgtRi7HmpQbV-WVEAWNV9T7cpddV5fDdsr0Rn59BOSOcYw66Kk6U5Gqwv277ECHZqKxPSOKeWVXLDso6LcvwY~~rmh0xoyRu2bGBniombr085k1lP26IGROl6YFVsoedqLrHbXNIZk~-wQ__&Key-Pair-Id=KNBS2THMRC385' }, { 'name' => 'ラピッドブラスター', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/weapon_illust/0a929d514403d07e1543e638141ebace947ffd539f5f766b42f4d6577d40d7b8_0.png?Expires=1736467200&Signature=l0YG5Y8XtEU3d4WOsE83Wi7qss4beFmJXnGBGuzvhv66HropU4MqVDp8NL4cTjiWFXQyrtIL~w9x1vNw-DlDmc65sAuWEjLoBSo1cfE-efprm9Q0~t-jqVbe6EP0Ouvkebqfn7lG82rFP2eu2bmywWWHH1S7Jbiw9z7t1yPKQSdaA2kZjopp0WCpx4c1BtBBEBdUe9gOZhCbQPN08XVq6cwZpz7lXwHMt9FqG6sSKv6zxRBMfcqByPXCHzBMV-Of4etmPvgQq5X-c1Xuqb1FE~4X7~SjJlKYhG9nBlsKC0isqzoyxCSxpMGqq2AQyFgy9Y3cNCyRipAdRykmEYEXaA__&Key-Pair-Id=KNBS2THMRC385' }], 'is_big_run' => false }] }
    end

    before do
      allow(Faraday).to receive(:new).and_return(stub_connection)
    end

    it 'get current salmon run' do
      expect(schedule.salmon_run_now.start_time).not_to be_nil
      expect(schedule.salmon_run_now.weapons.count).to be(4)
      expect(schedule.salmon_run_now.boss.name).not_to be_empty
    end
  end

  describe '#salmon_run_team_contest' do
    let(:success_response) do
      { 'results' => [{ 'start_time' => '2024-07-20T09:00:00+09:00', 'end_time' => '2024-07-22T09:00:00+09:00', 'boss' => { 'id' => '', 'name' => '' }, 'stage' => { 'id' => 0, 'name' => 'トキシラズいぶし工房', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/high_resolution/630d89698e3e260ef12cb2a32e1cb2c4c83c0e58fc882762da1fa2cea19a5260_0.png?Expires=1736467200&Signature=sQdV6OZXaSHAON9FAb0JFGxaJH5b3pHd0PBVyT~Dolw7JWgZybELhlCkR3FgZ118dA7FUzA~fjRqKXgfd0Ws1nQH6XUtKRPggckLF-GH7EzsOWqoZca~Bqr7Q893SY5psR-SD74DKMNgwyHV7dvenVuvcUn0NgkPOrucjsmbRS6R9s~i47fWkTx7bhY2FcEZKvhZknuf6h-aOFaPByvlRozsRaRLVUb3schtaAbG2YiaZTFR1WE0bMHSc-9P8ZoPSIz2smLbzQn1aNrMoOXjQSA98-IFRT8jK9vaDmxABJYsHwQXmllbg4x-t4y5U2o~wzJNoGx3WN5Uqm8xjDt0yA__&Key-Pair-Id=KNBS2THMRC385' }, 'weapons' => [{ 'name' => 'N-ZAP85', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/weapon_illust/e6dbf73aa6ff9d1feb61fcabadb2d31e08b228a9736b4f5d8a5baeab9b493255_0.png?Expires=1736467200&Signature=YumohnJpFIKCZfVyQotq-V-w5xwkreUqa0WmcS9yIn8rHzeveWDba0LElUO~ANM~mco7IoWwoWeki~oXYsW2rKPOdIN1YeyVxmOHQgdD78UoSY39MJIwfSUQrnZyrGzbnJyww~BKK8mZ6tno5dzgQHD1mhVPBbNwW00ys5BPU8gN79CBDGC0xLm1a2B~U6ABJ4Vqv-e88BrbVstbZp3uILfXTgOdwQqNcyRUeu3JcsGVO9WHcbfDsHGK~gNqPfLz5k0YmiBVU58ZOSpWuoYJK07Mne~mENnqvQdBnQQspzbXzH93T8hVPjJ4qZnTGg-s5h4bsGXiwsygdaFpnlbCmA__&Key-Pair-Id=KNBS2THMRC385' }, { 'name' => 'カーボンローラー', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/weapon_illust/29358fd25b6ad1ba9e99f5721f0248af8bde7f1f757d00cbbc7a8a6be02a880d_0.png?Expires=1736467200&Signature=S1GRenv~fRlEvAj2YedlX6ZS1oOhd7Gx9c9OL-sC~mrcBufaNNkiOGzc~S7AqorRGZSb7A30z0ODW02nGMv048fWBNukSpbcsUV21Ipv0kHcplChKGDLm2nTmlwqNy-3m~vkAT6LW~csAADVJrWbJk8zVgPNGR1q2kWgiDYgawg5wvnY-RMOGwjbImpnp98Jf9cZwlK2In6NXzSPNI20xEUCgvZiS6Stazc~8Z1jsmyjlbl64Zf6dokNBYZrSW8xZMUifle3LL0-YO2N8r7N6nQPbNNMYqJunJzvJfIUljVLzUvpRMfYISCM1AAjN~KFyoHTDYGrIsZhVyRl0J1dVw__&Key-Pair-Id=KNBS2THMRC385' }, { 'name' => 'ボトルガイザー', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/weapon_illust/db9f2ff8fab9f74c05c7589d43f132eacbff94154dcc20e09c864fced36d4d95_0.png?Expires=1736467200&Signature=kOLJktiPYPiCnEFd3KrB~dz3eXoJonQuoTwnwajSHqSWM2AOh6v33zBU6GPJYqaHZ3z80rlqXnrwqgwG4bH1G~HPV9Q-VTXxBaCUfo-uXynpntKmHL87HRlOhvfePtgkH5TJ4IiEQ0I-DM4dqR9~gfgl6TJLEiNQJ3XAnPpuGBSPaeTlslIQT7Tzpf-qHJbmz5124LmeIqTrBZtf0OrsFObLk1TxnWXIz~OfMD9clKkMWh4LhAVKaGo9yi~U7Gcnv~RgF9A3TygV92dKbE60DkU-ZoWuQY5sDZxigtSQejukNbbLSfHxPR09Iaib8H9qvOt4MxL5poGOoMunZnWF2w__&Key-Pair-Id=KNBS2THMRC385' }, { 'name' => 'キャンピングシェルター', 'image' => 'https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/weapon_illust/a7b1903741696c0ebeda76c9e16fa0a81ae4e37f5331ad6282fc2be1ae1c1c59_0.png?Expires=1736467200&Signature=Ev4O15rxMgsHqh3qabpiFHAUVjDICECgYCR13l26F0d7ChUHtyr8PoI5q2eHcvV8X07tS-d7AidVeJzXcW1u15z15d8gpvrnTelylsHDrTBvHaEwk1x-W4R5P9d0rRFiMQzBzbAqMAMTJ6f9a3b178X9x2zbdMX-r7xXkACEkKKGCqmZdPyHDmyW13lPlm95KrTRbJidP4Vcpv960nTVR5HfWT-q5RZR5m6BLyUfECUDP5z9vFYsTQUWFQsLUlJrcssXyiKxUGjCQpCkI7LLq8w6T2Sm1NW9uLpiT9G40e~X~V4L9I3zI~j4lJhunhQ3fF468WFXwOnc7zcbK30Olg__&Key-Pair-Id=KNBS2THMRC385' }], 'is_big_run' => false }] }
    end

    before do
      allow(Faraday).to receive(:new).and_return(stub_connection)
    end

    it 'get current salmon run team contest' do
      expect(schedule.salmon_run_team_contest.stage).not_to be_nil
      expect(schedule.salmon_run_team_contest.weapons.count).to be(4)
      expect(schedule.salmon_run_team_contest.boss.name).to be_empty
    end
  end
end
