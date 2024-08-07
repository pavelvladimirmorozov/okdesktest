RSpec.describe OkdeskApiService do
  describe '.create_company' do
    let(:user) { User.new }

    let(:company) { 
      UploadedCompany.new name: 'test',
        additional_name: 'test',
        site: 'test.test',
        email: 'test@test.test',
        phone: '+7-987-654-32-10',
        address: 'test test test test',
        comment: 'test'
    }

    subject { described_class.new(user).create_company(company) }

    context 'success' do
      let(:expected_result) { 
          UploadedCompany.new name: 'test',
            additional_name: 'test',
            site: 'test.test',
            email: 'test@test.test',
            phone: '+7-987-654-32-10',
            address: 'test test test test',
            coordinates_x: nil,
            coordinates_y: nil,
            comment: 'test',
            category_code: nil,
            active: true,
            request_status: 200,
            request_success: true,
            created_at: nil,
            updated_at: nil
      }

      let(:api_result) { Struct.new('Response', :success? , :status, :body).new true, 200, {
            name: 'test',
            additional_name: 'test',
            site: 'test.test',
            email: 'test@test.test',
            phone: '+7-987-654-32-10',
            address: 'test test test test',
            coordinates_x: nil,
            coordinates_y: nil,
            comment: 'test',
            category_code: nil,
            active: true,
            created_at: '01.01.',
            updated_at: nil,
            crm_1c_id: "67067c3a29a8"
          }.to_json 
      }

      before { allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(api_result) }

      it 'creates and returns company' do 
          expect(subject.name).to eq company.name
          expect(subject.additional_name).to eq company.additional_name
          expect(subject.site).to eq company.site
          expect(subject.email).to eq company.email
          expect(subject.phone).to eq company.phone
          expect(subject.address).to eq company.address
          expect(subject.comment).to eq company.comment
          expect(subject.request_status).to eq 200
          expect(subject.request_success).to eq true
      end
    end
  
    context 'failure' do
      let(:expected_result) {
          UploadedCompany.new name: 'test',
            additional_name: 'test',
            site: 'test.test',
            email: 'test@test.test',
            phone: '+7-987-654-32-10',
            address: 'test test test test',
            coordinates_x: nil,
            coordinates_y: nil,
            comment: 'test',
            category_code: nil,
            active: nil,
            request_status: 422,
            request_success: false,
            created_at: nil,
            updated_at: nil
      }

      let(:api_result) { Struct.new('Response', :success? , :status, :body).new false, 422, {
            errors: {
              "some_field": ["some error text"]
            }
          }.to_json
      }
    
      before { allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(api_result) }
    
      it 'creates and returns company' do
        expect(subject.name).to eq company.name
        expect(subject.additional_name).to eq company.additional_name
        expect(subject.site).to eq company.site
        expect(subject.email).to eq company.email
        expect(subject.phone).to eq company.phone
        expect(subject.address).to eq company.address
        expect(subject.comment).to eq company.comment
        expect(subject.request_status).to eq 422
        expect(subject.request_success).to eq false
      end
    end
  end
end
