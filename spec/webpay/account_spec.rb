require 'spec_helper'
describe WebPay::Account do
  describe '.retrieve' do
    before do
      stub_get_request('/account', 'account/retrieve')
    end

    subject(:account) { described_class.retrieve }
    its(:object) { should eq 'account' }
    its(:id) { should eq 'acct_2Cmdexb7J2r78rz' }
    its(:email) { should eq 'test-me@example.com' }
    its(:currencies_supported) { should eq ['jpy'] }
  end

  describe '.delete_data' do
    before do
      stub_delete_request('/account/data', 'account/delete')
    end

    it 'should return true' do
      expect(described_class.delete_data).to eq true
    end
  end
end
