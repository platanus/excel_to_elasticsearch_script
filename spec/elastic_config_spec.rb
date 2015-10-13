require "spec_helper"

describe ElasticConfig do
  let(:config) { ElasticConfig.new("spec/fixtures/test.yml") }

  it "returns the calculated columns" do
    expect(config.calculated_columns.size).to eq(1)
    month = config.calculated_columns["Mes"]
    expect(month["type"]).to eq("string")
    expect(month["calculated"]).to eq(true)
    expect(month["formula"]).to eq('self["Order Date"].year')
  end

  it "returns columns with mappings" do
    expect(config.columns_with_mappings.size).to eq(1)
    month = config.columns_with_mappings["Ship Mode"]
    expect(month["type"]).to eq("string")
  end
end
