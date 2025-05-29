extends LandmarkTemplate
class_name SettlementTemplate

# A value of 1.0 represents a settlement that will slowly but surely adapt new
# technology.
# Value > 1.0 will increase the rate at which this settlement will adapt.
# Value < 1.0 will decrease the rate, with 0.5 representing settlements that are 
# always one generation behind, and 0.0 representing settlements that will never
# adapt.
export (float) var tech_advancement_modifier : float = 1.0
# A value of 1.0 represents a settlement that is well-off.
# Value < 1.0 represents poverty, with complete economic colaspe at 0.0.
# Value > 1.0 represents richness, with 2.0 being the max.
export (float) var wealth_modifier : float = 1.0
# A value of 1.0 represents a content settlement.
# Value > 1.0 represents a more optimistic or satisfied settlement.
# Value < 1.0 represents a pessimistic or dissatified settlement, with 0.0 sending
# it into anarchy.
export (float) var hapiness_modifier : float = 1.0
# A value of 1.0 represents a well-armed settlement, whether through a well-train
# militia or adequate civilzation military presence.
# Value > 1.0 features better security, with 2.0 the equivalent to a militant 
# city-state.
# Value < 1.0 features a weaker or lacking defense, with 0.0 a valid reason to conquer
# this settlement.
# Actual defense may also rely on the tech_advancement_modifer as well.
export (float) var defense_modifier : float = 1.0
export (float) var population_modifier : float = 1.0
