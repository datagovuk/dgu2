# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DGUWeb.Repo.insert!(%DGUWeb.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DGUWeb.Repo, as: R 
alias DGUWeb.Theme, as: T
alias DGUWeb.Publisher, as: P 

# Themes ######################################################################

R.delete_all T

R.insert(%T{
    name: "business-economy",
    title: "Business and Economy",
    description: "Small businesses, industry, imports, exports and trade"
})

R.insert(%T{
    name: "environment",
    title: "Environment",
    description: "Weather, flooding, rivers, air quality, geology and agriculture"
})

R.insert(%T{
    name: "mapping",
    title: "Mapping",
    description: "Addresses, boundaries, land ownership, aerial photographs, seabed and land terrain"
})


R.insert(%T{
    name: "crime-justice",
    title: "Crime and Justice",
    description: "Courts, police, prisons, offenders, borders and immigration"
})


R.insert(%T{
    name: "government",
    title: "Government",
    description: "Staff numbers and pay, local councillors and department business plans"
})


R.insert(%T{
    name: "society",
    title: "Society",
    description: "Employment, benefits, household finances, poverty and population"
})

R.insert(%T{
    name: "defence",
    title: "Defence",
    description: "Armed forces, health and safety, search and rescue"
})

R.insert(%T{
    name: "government-spending",
    title: "Government Spending",
    description: "Includes all payments by government departments over £25,000"
})

R.insert(%T{
    name: "towns-cities",
    title: "Towns and Cities",
    description: "Includes housing, urban planning, leisure, waste and energy consumption"
})

R.insert(%T{
    name: "education",
    title: "Education",
    description: "Students, training, qualifications and the National Curriculum"
})

R.insert(%T{
    name: "health",
    title: "Health",
    description: "Includes smoking, drugs, alcohol, medicine performance and hospitals"
})

R.insert(%T{
    name: "transport",
    title: "Transport",
    description: "Includes housing, urban planning, leisure, waste and energy consumption"
})


# Themes ######################################################################

R.delete_all P

R.insert(%P{
    name: "cabinet-office",
    title: "Cabinet Office",
    description: "The Cabinet Office supports the Prime Minister and Deputy Prime Minister, and ensure the effective running of government. We are also the corporate headquarters for government, in partnership with HM Treasury, and we take the lead in certain critical policy areas. CO is a ministerial department, supported by 18 agencies and public bodies",
    abbreviation: "CO",    
    url: "https://www.gov.uk/government/organisations/cabinet-office",    
    category: "ministerial-department",
    closed: false, 
})

R.insert(%P{
    name: "department-for-environment-food-rural-affairs",
    title: "Department for Environment, Food and Rural Affairs",
    description: "We are the UK government department responsible for policy and regulations on environmental, food and rural issues. Our priorities are to grow the rural economy, improve the environment and safeguard animal and plant health. Defra is a ministerial department, supported by 38 agencies and public bodies.",
    abbreviation: "DEFRA",    
    url: "https://www.gov.uk/government/organisations/department-for-environment-food-rural-affairs",    
    category: "ministerial-department",
    closed: false, 
})

R.insert(%P{
    name: "department-for-transport",
    title: "Department for Transport",
    description: "We work with our agencies and partners to support the transport network that helps the UK’s businesses and gets people and goods travelling around the country. We plan and invest in transport infrastructure to keep the UK on the move. DFT is a ministerial department, supported by 22 agencies and public bodies.",
    abbreviation: "DfT",    
    url: "https://www.gov.uk/government/organisations/department-for-transport",    
    category: "ministerial-department",
    closed: false, 
})

