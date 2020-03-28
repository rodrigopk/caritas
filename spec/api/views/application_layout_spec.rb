# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Views::ApplicationLayout, type: :view do
  let(:layout) do
    Api::Views::ApplicationLayout.new({ format: :html }, 'contents')
  end
  let(:rendered) { layout.render }

  it 'contains application name' do
    expect(rendered).to include('Api')
  end
end
