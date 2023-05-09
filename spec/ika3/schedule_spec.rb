# frozen_string_literal: true

RSpec.describe Ika3::Schedule do
  let(:schedule) { described_class.new(contact_info) }
  let(:contact_info) { '@YutaGoto_rspec' }

  describe '#regular_now' do
    it 'get current regular match' do
      expect(schedule.regular_now).to include('start_time')
      expect(schedule.regular_now.stages.count).to be(2)
    end
  end

  describe '#bankara_open_next' do
    it 'get next bankara open match' do
      expect(schedule.bankara_open_next).to include('start_time')
      expect(schedule.bankara_open_next.stages.count).to be(2)
    end
  end

  describe '#bankara_challenge_next' do
    it 'get next bankara challenge match' do
      expect(schedule.bankara_challenge_next).to include('start_time')
      expect(schedule.bankara_challenge_next.stages.count).to be(2)
    end
  end

  describe '#x_now' do
    it 'get current x match' do
      expect(schedule.x_now).to include('start_time')
      expect(schedule.x_now.stages.count).to be(2)
    end
  end

  describe '#fest_now' do
    let(:fest) { schedule.fest_now.is_fest }

    it 'get current fest match' do
      expect(schedule.fest_now).to include('start_time')
      if fest
        expect(schedule.fest_now.stages.count).to be(stages_count)
      else
        expect(schedule.fest_now.stages).to be_nil
      end
    end
  end

  describe '#salmon_run_now' do
    it 'get current salmon run' do
      expect(schedule.salmon_run_now).to include('start_time')
      expect(schedule.salmon_run_now.weapons.count).to be(4)
    end
  end

  describe '#salmon_run_team_contest' do
    it 'get current salmon run team contest' do
      expect(schedule.salmon_run_team_contest).to be_nil
    end
  end
end
