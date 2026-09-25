(in-package #:org.shirakumo.precise-time)

;; DEFINE-CONSTANT expands to DEFUN. TorCL currently fails to replace the
;; protocol defaults, which were installed through SETF FDEFINITION
;; (TorCL issue bliss-eezi), so replace those accessors by the same mechanism.
(setf (fdefinition '%precise-time-units-per-second)
      (lambda () 1000000000)
      (fdefinition '%monotonic-time-units-per-second)
      (lambda () 1000000000))

(define-implementation get-precise-time ()
  ;; TorCL samples both parts atomically so they cannot straddle a wall-clock
  ;; second boundary.
  (torcl-ext:get-precise-time))

(define-implementation get-monotonic-time ()
  (truncate (torcl-ext:real-time-nanoseconds) 1000000000))
