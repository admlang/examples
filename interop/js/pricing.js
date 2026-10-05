// The shop's pricing rules. An ordinary ES module: the functions it exports
// are the ones main.adm declares.

const codes = { SPRING: 0.10, STAFF: 0.20 }

export function total(items) {
    return items.reduce((sum, item) => sum + item.price * item.quantity, 0)
}

// Throws for a code the shop does not know; the ADM caller gets it as an error.
export function discount(amount, code) {
    if (!(code in codes)) throw new RangeError(`unknown discount code ${code}`)
    return amount * codes[code]
}

export const labels = (items) => items.map((item) => `${item.quantity} x ${item.name}`)

// `prices` is a Float64Array over the caller's own array: what is written here
// is written there.
export function roundAll(prices) {
    for (let i = 0; i < prices.length; i++) prices[i] = Math.round(prices[i] * 100) / 100
    return prices.length
}

// `audit` is a function the program gives the script.
export function checkout(items, code) {
    const gross = total(items)
    const off = code ? discount(gross, code) : 0
    audit(`checkout of ${items.length} lines, ${off.toFixed(2)} off`)
    return gross - off
}
