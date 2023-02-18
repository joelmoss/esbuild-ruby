# frozen_string_literal: true

describe 'Esbuild.transform' do
  it 'transforms typescript' do
    result = Esbuild.transform('let x: number = 1', loader: :ts)
    expect(result.code).to be == "let x = 1;\n"
  end
end
