# frozen_string_literal: true

describe Esbuild::VERSION do
  it "has a major.minor.patch version" do
    expect(subject).to be =~ /\d+\.\d+\.\d+/
  end
end
