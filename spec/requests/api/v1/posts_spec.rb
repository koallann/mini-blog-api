require 'rails_helper'

RSpec.describe 'Post API', type: :request do
	before { host! 'api.miniblog.dev' }
	let(:headers) do
		{
			'Content-Type' => Mime[:json].to_s,
			'Accept' => 'application/vnd.miniblog.v1'
		}
	end


	describe 'GET /posts' do
		before do
			create_list(:post, 5)
			get '/posts', params: {}, headers: headers
		end

		it 'returns status code 200' do
			expect(response).to have_http_status(200)
		end

		it 'returns 5 posts from database' do
			posts_response = JSON.parse(response.body, symbolize_names: true)
			expect(posts_response[:posts].count).to eq(5)
		end
	end


	describe 'GET /posts/:id' do
		let(:post) { create(:post) }
		let(:post_id) { post.id }

		before { get "/posts/#{post_id}", params: {}, headers: headers }

		context 'when the post exists' do
			it 'returns status code 200' do
				expect(response).to have_http_status(200)
			end

			it 'returns the json data for the post' do
				post_response = JSON.parse(response.body, symbolize_names: true)
				expect(post_response[:title]).to eq(post.title)
			end
		end

		context 'when the post does not exist' do
			let(:post_id) { -1 }

			it 'returns status code 404' do
				expect(response).to have_http_status(404)
			end
		end
	end


	describe 'POST /posts' do
		before do
			post '/posts', params: { post: post_params }.to_json, headers: headers
		end

		context 'when the request params are valid' do
			let(:post_params) { attributes_for(:post) }

			it 'returns status code 201' do
				expect(response).to have_http_status(201)
			end

			it 'returns the json data for the created post' do
				post_response = JSON.parse(response.body, symbolize_names: true)
				expect(post_response[:title]).to eq(post_params[:title])
			end
		end

		context 'when the request params are invalid' do
			let(:post_params) { attributes_for(:post, title: '') }

			it 'returns status code 422' do
				expect(response).to have_http_status(422)
			end

			it 'returns the json data for the errors' do
				post_response = JSON.parse(response.body, symbolize_names: true)
				expect(post_response).to have_key(:errors)
			end
		end
	end

end