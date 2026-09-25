;;;; TorCL backend regression without the Parachute test dependency.

(in-package #:cl-user)

(assert (member :torcl *features*))
(assert (null (find-package :cffi)))

(asdf:load-system :precise-time :force t)

(assert (null (find-package :cffi)))
(assert (= 1000000000
           org.shirakumo.precise-time:precise-time-units-per-second))
(assert (= 1000000000
           org.shirakumo.precise-time:monotonic-time-units-per-second))

(multiple-value-bind (seconds nanoseconds)
    (org.shirakumo.precise-time:get-precise-time)
  (assert (integerp seconds))
  (assert (integerp nanoseconds))
  (assert (<= 0 nanoseconds))
  (assert (< nanoseconds 1000000000))
  (assert (<= (abs (- seconds (get-universal-time))) 1)))

(multiple-value-bind (seconds nanoseconds)
    (org.shirakumo.precise-time:get-monotonic-time)
  (let ((before (+ (* seconds 1000000000) nanoseconds)))
    (sleep 0.01)
    (multiple-value-bind (later-seconds later-nanoseconds)
        (org.shirakumo.precise-time:get-monotonic-time)
      (let ((after (+ (* later-seconds 1000000000) later-nanoseconds)))
        (assert (< before after))
        (assert (< (- after before) 5000000000))))))

(format t "TORCL-PRECISE-TIME-OK~%")
