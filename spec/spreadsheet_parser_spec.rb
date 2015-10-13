require "spec_helper"

describe SpreadsheetParser do
  let(:book) { SpreadsheetParser.open("./spec/fixtures/tiny.xlsx") }

  context "returns rows" do
    it "parses from the 3rd row" do
      row = book.rows.first
      expect(row[0]).to eq 1
      expect(row[3]).to eq "Low"
    end

    it "returns the correct number of results" do
      expect(book.rows.length).to eq 101
    end
  end

  context "returns the columns" do
    it "returns a hash of columns" do
      columns = book.columns
      expect(columns.size).to eq(21)
    end

    it "has the current type for the column" do
      columns = book.columns
      expect(columns["Sales"]).to eq("float")
    end
  end
end
