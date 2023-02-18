# frozen_string_literal: true

describe "Esbuild.build" do
  it "builds from stdin" do
    result = Esbuild.build(stdin: {contents: %(export * from "./another-file"),
                                   sourcefile: "source.js"}, write: false, metafile: true)
    expect(result.metafile.outputs["stdin.js"]).to be_a Esbuild::BuildResult::Metafile::Output
  end

  it ":define option" do
    result = Esbuild.build(stdin: {contents: %(cool), sourcefile: "source.js"}, write: false,
      metafile: true, define: {cool: "yes"})
    expect(result.metafile.outputs["stdin.js"]).to be_a Esbuild::BuildResult::Metafile::Output
  end

  it "raises on unknown entry point" do
    expect do
      Esbuild.build(entry_points: ["non-existent"])
    end.to raise_exception(Esbuild::BuildFailureError, message: be =~ /Could not resolve "non-existent"/)
  end
end
