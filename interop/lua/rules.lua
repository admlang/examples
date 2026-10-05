-- The shop's customer rules. A Lua module: the table it returns holds the
-- functions main.adm declares.
local M = {}

function M.discount(customer)
    if customer.years >= 5 then return 0.15 end
    return customer.orders > 10 and 0.05 or 0
end

-- Returns a table; the ADM caller gets it as a struct.
function M.badge(customer)
    local level = customer.years >= 5 and "gold" or "basic"
    return {
        title = customer.name .. " (" .. level .. ")",
        perks = { "newsletter", level == "gold" and "free shipping" or "birthday coupon" },
    }
end

-- Raises an error for an order the shop cannot ship; the ADM caller gets it
-- as an error.
function M.shipping(country, weight)
    local rates = { RO = 2.5, DE = 4.0 }
    local rate = rates[country]
    if not rate then error("no shipping to " .. country, 0) end
    return rate * weight
end

-- `audit` is a function the program gives the script.
function M.welcome(customer)
    audit("welcome mail for " .. customer.name)
    return #customer.name
end

return M
