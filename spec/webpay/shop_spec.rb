require 'spec_helper'
describe WebPay::Shop do
  describe '.create' do
    let(:params) {{
        :description => 'Sample Shop',
      }}
    before do
      stub_post_request('/shops', 'shops/create', params)
    end
    subject(:shop) { described_class.create(params)}

    its(:id) { should eq 'sh_9hg6Awd357ywfBk' }
    its(:description) { should eq "Sample Shop" }
  end

  describe '.retrieve' do
    let(:id) { 'sh_9hg6Awd357ywfBk' }
    before do
      stub_get_request("/shops/#{id}", 'shops/retrieve')
    end

    subject(:shop) { described_class.retrieve(id) }
    its(:id) { should eq id }
  end

  describe '.all' do
    before do
      stub_get_request("/shops?count=3&offset=0&created[gt]=1378000000", 'shops/all')
    end

    subject(:list) { described_class.all(count: 3, offset: 0, created: { gt: 1378000000 }) }
    its(:url) { should eq '/v1/shops' }
    its(:count) { should eq 3 }
    it 'data.first.description' do
      expect(list.data.first.description).to eq 'Sample Shop'
    end
  end

  describe '#save' do
    let(:id) { 'sh_9hg6Awd357ywfBk' }
    let(:description) { 'Updated shop' }
    before do
      stub_get_request("/shops/#{id}", 'shops/retrieve')
      stub_post_request("/shops/#{id}", 'shops/update', description: description)
    end

    it 'should update information of the retrieved shop' do
      shop = described_class.retrieve(id)
      shop.description = description
      shop.save

      expect(shop.description).to eq description
    end
  end
end
