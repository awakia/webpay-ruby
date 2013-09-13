require 'spec_helper'
describe WebPay::Charge do
  describe '.create' do
    subject(:charge) { WebPay::Charge.create(params)}

    describe 'with card' do
      let(:params) {{
          :amount=>'1000',
          :currency=>'jpy',
          :card=>
          {:number=>'4242-4242-4242-4242',
            :exp_month=>'12',
            :exp_year=>'2015',
            :cvc=>'123',
            :name=>'YUUKO SHIONJI'},
          :description=>'Test Charge from Java'
        }}
      before do
        stub_post_request('/charges', 'charges/create_with_card', params)
      end

      its(:id) { should eq 'ch_2SS17Oh1r8d2djE' }
      its(:description) { should eq "Test Charge from Java" }
      it 'card.name' do
        expect(charge.card.name).to eq 'YUUKO SHIONJI'
      end
    end

    describe 'with customer' do
      let(:params) {{
          :amount=>'1000',
          :currency=>'jpy',
          :customer => 'cus_fgR4vI92r54I6oK',
          :description=>'Test Charge from Java'
        }}
      before do
        stub_post_request('/charges', 'charges/create_with_customer', params)
      end

      its(:id) { should eq 'ch_2SS4fK4IL96535y' }
      it 'card.name' do
        expect(charge.card.name).to eq 'KEI KUBO'
      end
    end
  end

  describe '.retrieve' do
    let(:id) { 'ch_bWp5EG9smcCYeEx' }
    before do
      stub_get_request("/charges/#{id}", 'charges/retrieve')
    end

    subject(:charge) { described_class.retrieve(id) }
    its(:id) { should eq id }
    it 'card.fingerprint' do
      expect(charge.card.fingerprint).to eq '215b5b2fe460809b8bb90bae6eeac0e0e0987bd7'
    end
  end

  describe '.all' do
    context 'with craeted[gt]' do
      before do
        stub_get_request("/charges?limit=3&offset=0&created[gt]=1378000000", 'charges/all')
      end

      subject(:list) { described_class.all(limit: 3, offset: 0, created: { gt: 1378000000 }) }
      its(:url) { should eq '/v1/charges' }
      its(:count) { should eq 11 }
      it 'data.first.description' do
        expect(list.data.first.description).to eq 'Test Charge from Java'
      end
    end

    context 'with customer' do
      before do
        stub_get_request("/charges?customer=cus_fgR4vI92r54I6oK", 'charges/all')
      end

      it 'should respond the list' do
        list = described_class.all(customer: 'cus_fgR4vI92r54I6oK')
        expect(list.url).to eq '/v1/charges'
      end
    end
  end

  describe '#refund' do
    let(:id) { 'ch_bWp5EG9smcCYeEx' }
    before do
      stub_get_request("/charges/#{id}", 'charges/retrieve')
      stub_post_request("/charges/#{id}/refund", 'charges/refund', amount: '400')
    end

    it 'should refund the retrieved charge' do
      charge = described_class.retrieve(id)
      expect(charge.refunded).to eq false
      charge.refund(amount: 400)
      expect(charge.refunded).to eq true
    end
  end

  describe '#capture' do
    let(:id) { 'ch_2X01NDedxdrRcA3' }
    before do
      stub_get_request("/charges/#{id}", 'charges/retrieve_not_captured')
      stub_post_request("/charges/#{id}/capture", 'charges/capture', amount: '1000')
    end

    it 'should capture the retrieved charge' do
      charge = described_class.retrieve(id)
      expect(charge.captured).to eq false
      charge.capture(amount: 1000)
      expect(charge.captured).to eq true
    end
  end
end
