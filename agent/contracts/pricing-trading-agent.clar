;; AI Market Pricing and Trading Agent
;; A smart contract to help informal traders track market trends and make informed decisions

;; Error codes
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_PRODUCT_EXISTS (err u101))
(define-constant ERR_PRODUCT_NOT_FOUND (err u102))
(define-constant ERR_INVALID_PRICE (err u103))
(define-constant ERR_INVALID_QUANTITY (err u104))
(define-constant ERR_INVALID_DEAL (err u105))

;; Data structures
(define-map products
  { product-id: uint }
  {
    name: (string-ascii 50),
    category: (string-ascii 30),
    created-by: principal,
    created-at: uint
  }
)

(define-map price-history
  { product-id: uint, timestamp: uint }
  {
    price: uint,
    reporter: principal,
    location: (string-ascii 50),
    notes: (optional (string-ascii 100))
  }
)

(define-map bulk-deals
  { deal-id: uint }
  {
    product-id: uint,
    quantity: uint,
    total-price: uint,
    price-per-unit: uint,
    location: (string-ascii 50),
    expiry: uint,
    contact: (string-ascii 100),
    created-by: principal,
    created-at: uint
  }
)

(define-map market-trends
  { product-id: uint }
  {
    avg-price-7d: uint,
    avg-price-30d: uint,
    price-trend: (string-ascii 10),
    last-updated: uint
  }
)

(define-map user-profiles
  { user: principal }
  {
    location: (string-ascii 50),
    preferred-categories: (list 10 (string-ascii 30)),
    reputation: uint,
    joined-at: uint
  }
)

;; Variables
(define-data-var next-product-id uint u1)
(define-data-var next-deal-id uint u1)
(define-data-var contract-owner principal tx-sender)

;; Read-only functions

(define-read-only (get-product (product-id uint))
  (match (map-get? products { product-id: product-id })
    product (ok product)
    ( err ERR_PRODUCT_NOT_FOUND)
  )
)

(define-read-only (get-market-trend (product-id uint))
  (match (map-get? market-trends { product-id: product-id })
    trend (ok trend)
    ( err ERR_PRODUCT_NOT_FOUND)
  )
)

(define-read-only (get-bulk-deals-for-product (product-id uint))
  (ok (list)) ;; Stub implementation
)

(define-read-only (get-recommendations (trader principal))
  (match (map-get? user-profiles { user: trader })
    profile (ok (list {
      product-id: u1,
      action: "buy",
      reason: "Price trending down, good time to stock up",
      confidence: u80
    }))
    (ok (list))
  )
)

;; Public functions

(define-public (register-product (name (string-ascii 50)) (category (string-ascii 30)))
  (let (
    (product-id (var-get next-product-id))
    (current-time stacks-block-height)
  )
  (asserts! (is-none (map-get? products { product-id: product-id })) ERR_PRODUCT_EXISTS)

  (map-set products
    { product-id: product-id }
    {
      name: name,
      category: category,
      created-by: tx-sender,
      created-at: current-time
    })
  (var-set next-product-id (+ product-id u1))
  (ok product-id))
)

(define-public (report-price (product-id uint) (price uint) (location (string-ascii 50)) (notes (optional (string-ascii 100))))
  (let (
    (current-time stacks-block-height)
  )
  (asserts! (is-some (map-get? products { product-id: product-id })) ERR_PRODUCT_NOT_FOUND)
  (asserts! (> price u0) ERR_INVALID_PRICE)

  (map-set price-history
    { product-id: product-id, timestamp: current-time }
    {
      price: price,
      reporter: tx-sender,
      location: location,
      notes: notes
    })

  ;; Simplified trend update
  (map-set market-trends
    { product-id: product-id }
    {
      avg-price-7d: price,
      avg-price-30d: price,
      price-trend: "stable",
      last-updated: current-time
    })

  (ok true))
)

(define-public (post-bulk-deal (product-id uint) (quantity uint) (total-price uint) (location (string-ascii 50)) (expiry uint) (contact (string-ascii 100)))
  (let (
    (deal-id (var-get next-deal-id))
    (current-time stacks-block-height)
  )
  (asserts! (is-some (map-get? products { product-id: product-id })) ERR_PRODUCT_NOT_FOUND)
  (asserts! (> quantity u0) ERR_INVALID_QUANTITY)
  (asserts! (> total-price u0) ERR_INVALID_PRICE)
  (asserts! (> expiry current-time) ERR_INVALID_DEAL)

  (let (
    (price-per-unit (/ total-price quantity))
  )
    (map-set bulk-deals
      { deal-id: deal-id }
      {
        product-id: product-id,
        quantity: quantity,
        total-price: total-price,
        price-per-unit: price-per-unit,
        location: location,
        expiry: expiry,
        contact: contact,
        created-by: tx-sender,
        created-at: current-time
      })

    (var-set next-deal-id (+ deal-id u1))
    (ok deal-id)
  ))
)

(define-public (update-profile (location (string-ascii 50)) (preferred-categories (list 10 (string-ascii 30))))
  (let (
    (current-time stacks-block-height)
    (joined-at (match (map-get? user-profiles { user: tx-sender })
      some-profile (get joined-at some-profile)
      current-time))
  )
  (map-set user-profiles
    { user: tx-sender }
    {
      location: location,
      preferred-categories: preferred-categories,
      reputation: u100,
      joined-at: joined-at
    })
  (ok true))
)
