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

  describe '#salmon_run_now' do
    it 'get current salmon run' do
      expect(schedule.salmon_run_now).to include('start_time')
      expect(schedule.salmon_run_now.weapons.count).to be(4)
    end
  end
end
