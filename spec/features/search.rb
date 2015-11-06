describe "the display of existing plants in the search" do
  it "shows the list of plants" do
    visit "/search/index"
    expect(page).to have_content 'Suche nach'
  end
end
