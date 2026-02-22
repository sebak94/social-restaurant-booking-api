vegan = DietaryRestriction.find_or_create_by!(name: "Vegan")
vegetarian = DietaryRestriction.find_or_create_by!(name: "Vegetarian")
paleo = DietaryRestriction.find_or_create_by!(name: "Paleo")
gluten_free = DietaryRestriction.find_or_create_by!(name: "Gluten-free")

jack = Diner.find_or_create_by!(name: "Jack")
jill = Diner.find_or_create_by!(name: "Jill")
jane = Diner.find_or_create_by!(name: "Jane")
bob = Diner.find_or_create_by!(name: "Bob")

jack.dietary_restrictions = [ vegan ]
jill.dietary_restrictions = [ vegetarian ]
jane.dietary_restrictions = [ vegan, gluten_free ]
bob.dietary_restrictions = []

green_garden = Restaurant.find_or_create_by!(name: "Green Garden")
green_garden.dietary_restrictions = [ vegan, vegetarian, gluten_free ]
green_garden.tables.find_or_create_by!(capacity: 2)
green_garden.tables.find_or_create_by!(capacity: 4)
green_garden.tables.find_or_create_by!(capacity: 6)

steakhouse = Restaurant.find_or_create_by!(name: "The Steakhouse")
steakhouse.dietary_restrictions = [ paleo ]
steakhouse.tables.find_or_create_by!(capacity: 2)
steakhouse.tables.find_or_create_by!(capacity: 4)

fusion_bistro = Restaurant.find_or_create_by!(name: "Fusion Bistro")
fusion_bistro.dietary_restrictions = [ vegan, vegetarian, paleo, gluten_free ]
fusion_bistro.tables.find_or_create_by!(capacity: 4)
fusion_bistro.tables.find_or_create_by!(capacity: 8)

no_restriction = Restaurant.find_or_create_by!(name: "Classic Diner")
no_restriction.tables.find_or_create_by!(capacity: 4)
no_restriction.tables.find_or_create_by!(capacity: 6)
