# frozen_string_literal: true

RSpec.describe Ika3::Weapon do
  let(:weapon) { { name: weapon_name, sub: sub_name, special: special_name } }
  let(:weapon_name) { 'わかばシューター' }
  let(:sub_name) { 'スプラボム' }
  let(:special_name) { 'グレートバリア' }
  let(:key_name) { :splattershot_jr }

  describe '#find_by_name' do
    it 'get weapon info from name' do
      expect(described_class.find_by_name(weapon_name).name).to eq weapon_name
    end
  end

  describe '#filter_by_sub' do
    it 'get weapon info list from sub weapon' do
      expect(described_class.filter_by_sub(sub_name).map(&:name)).to include weapon_name
    end
  end

  describe '#name' do
    it 'get weapon name' do
      expect(described_class.find(key_name).name).to eq weapon_name
    end
  end

  describe '#sub' do
    it 'get sub weapon name' do
      expect(described_class.find(key_name).sub).to eq sub_name
    end
  end

  describe '#special' do
    it 'get special name' do
      expect(described_class.find(key_name).special).to eq special_name
    end
  end
end
