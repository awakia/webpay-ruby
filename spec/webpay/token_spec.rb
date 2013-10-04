require 'spec_helper'
describe WebPay::Token do
  describe '.create' do
    let(:params) {{:number=>'4242-4242-4242-4242',
          :exp_month=>'12',
          :exp_year=>'2015',
          :cvc=>'123',
          :name=>'YUUKO SHIONJI'}}
    before do
      stub_post_request('/tokens', 'tokens/create', params)
    end
    subject(:token) { WebPay::Token.create(params)}

    its(:id) { should eq 'tok_3dw2T20rzekM1Kf' }
    its(:used) { should eq false }
    it 'card.name' do
      expect(token.card.name).to eq 'YUUKO SHIONJI'
    end
  end

  describe '.retrieve' do
    let(:id) { 'tok_3dw2T20rzekM1Kf' }
    before do
      stub_get_request("/tokens/#{id}", 'tokens/retrieve')
    end

    subject(:token) { described_class.retrieve(id) }
    its(:id) { should eq id }
    it 'card.fingerprint' do
      expect(token.card.fingerprint).to eq '215b5b2fe460809b8bb90bae6eeac0e0e0987bd7'
    end
  end
end
