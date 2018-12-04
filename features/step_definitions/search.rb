When(/^I go to item search$/) do
  visit root_path
end

Then(/^I should see the item search$/) do
  expect(page).to have_content("Log In")
end
