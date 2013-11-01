require 'spec_helper'
describe WebPay::Customer do
  describe '.create' do
    let(:params) {{
        :description => 'Test Customer from Java',
        :email => 'customer@example.com',
        :card=>
        {:number=>'4242-4242-4242-4242',
          :exp_month=>'12',
          :exp_year=>'2015',
          :cvc=>'123',
          :name=>'YUUKO SHIONJI'}
      }}
    before do
      stub_post_request('/customers', 'customers/create', params)
    end
    subject(:customer) { WebPay::Customer.create(params)}

    its(:id) { should eq 'cus_39o4Fv82E1et5Xb' }
    its(:description) { should eq "Test Customer from Java" }
    it 'active_card.name' do
      expect(customer.active_card.name).to eq 'YUUKO SHIONJI'
    end
  end

  describe '.retrieve' do
    let(:id) { 'cus_39o4Fv82E1et5Xb' }
    before do
      stub_get_request("/customers/#{id}", 'customers/retrieve')
    end

    subject(:customer) { described_class.retrieve(id) }
    its(:id) { should eq id }
    it 'active_card.fingerprint' do
      expect(customer.active_card.fingerprint).to eq '215b5b2fe460809b8bb90bae6eeac0e0e0987bd7'
    end
  end

  describe '.retrieve deleted instance' do
    let(:id) { 'cus_7GafGMbML8R28Io' }
    before do
      stub_get_request("/customers/#{id}", 'customers/retrieve_deleted')
    end

    subject(:customer) { described_class.retrieve(id) }
    its(:id) { should eq id }
    its(:deleted) { should eq true }
    it { should be_deleted }
  end

  describe '.all' do
    before do
      stub_get_request("/customers?count=3&offset=0&created[gt]=1378000000", 'customers/all')
    end

    subject(:list) { described_class.all(count: 3, offset: 0, created: { gt: 1378000000 }) }
    its(:url) { should eq '/v1/customers' }
    its(:count) { should eq 4 }
    it 'data.first.description' do
      expect(list.data.first.description).to eq 'Test Customer from Java'
    end
  end

  describe '#save' do
    let(:id) { 'cus_39o4Fv82E1et5Xb' }
    let(:email) { 'newmail@example.com' }
    let(:description) { 'New description' }
    let(:card_info) { {:number=>'4242-4242-4242-4242',
        :exp_month=>'12',
        :exp_year=>'2016',
        :cvc=>'123',
        :name=>'YUUKO SHIONJI'} }
    before do
      stub_get_request("/customers/#{id}", 'customers/retrieve')
      stub_post_request("/customers/#{id}", 'customers/update',
        email: email,
        description: description,
        card: card_info)
    end

    it 'should update information of the retrieved customer' do
      customer = described_class.retrieve(id)
      customer.email = email
      customer.description = description
      customer.card = card_info
      customer.save

      expect(customer.email).to eq email
      expect(customer.description).to eq description
      expect(customer.active_card.exp_year).to eq 2016
    end
  end

  describe '#delete' do
    let(:id) { 'cus_39o4Fv82E1et5Xb' }
    before do
      stub_get_request("/customers/#{id}", 'customers/retrieve')
      stub_delete_request("/customers/#{id}", 'customers/delete')
    end

    it 'should delete the retrieved customer' do
      customer = described_class.retrieve(id)
      expect(customer.delete).to eq true
    end
  end
end
