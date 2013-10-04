require 'spec_helper'
describe WebPay::Event do
  describe '.retrieve' do
    let(:id) { 'evt_39o9oUevb5NCeM1' }
    before do
      stub_get_request("/events/#{id}", 'events/retrieve')
    end

    subject(:event) { described_class.retrieve(id) }
    its(:id) { should eq id }
    its(:type) { should eq 'customer.created' }
    it 'data.object' do
      expect(event.data.object).to be_instance_of(WebPay::Customer)
      expect(event.data.object.email).to eq 'customer@example.com'
    end
  end

  describe '.all' do
    before do
      stub_get_request("/events?type=*.created", 'events/all_with_type')
    end

    subject(:list) { described_class.all(type: '*.created') }
    its(:url) { should eq '/v1/events' }
    its(:count) { should eq 5 }
    it 'data.first.type' do
      expect(list.data.first.type).to eq 'customer.created'
    end
  end
end
