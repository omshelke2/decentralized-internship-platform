;; Internship DAO for Students Community-managed listings
;; A minimal DAO-style contract with two functions

(define-map internships uint
  {
    title: (string-ascii 64),
    description: (string-ascii 256),
    creator: principal
  }
)

(define-data-var internship-count uint u0)

;; Error constants
(define-constant err-invalid-title (err u100))
(define-constant err-invalid-description (err u101))
(define-constant err-not-creator (err u102))
(define-constant err-no-such-id (err u103))

;; 1. Add an internship listing
(define-public (add-internship (title (string-ascii 64)) (description (string-ascii 256)))
  (begin
    (asserts! (> (len title) u0) err-invalid-title)
    (asserts! (> (len description) u0) err-invalid-description)
    (let ((id (+ u1 (var-get internship-count))))
      (map-set internships id {
        title: title,
        description: description,
        creator: tx-sender
      })
      (var-set internship-count id)
      (ok id)
    )
  )
)

;; 2. Get internship details by ID
(define-read-only (get-internship (id uint))
  (let ((listing (map-get? internships id)))
    (ok (match listing l
          (some l)
          none
    ))
  )
)
