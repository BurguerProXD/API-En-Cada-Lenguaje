(ql:quickload :usocket)

(defparameter *port* 8101)
(defparameter *imagenes* 
    '("https://picsum.photos/800/600?random=2100"
      "https://picsum.photos/800/600?random=2101"
      "https://picsum.photos/800/600?random=2102"
      "https://picsum.photos/800/600?random=2103"
      "https://picsum.photos/800/600?random=2104"))

(defun start-server ()
    (let ((server-socket (usocket:socket-listen "127.0.0.1" *port*)))
        (format t "API en Common Lisp escuchando en http://localhost:~a~%" *port*)
        (loop
            (let ((client (usocket:socket-accept server-socket)))
                (usocket:with-client-socket (socket client)
                    (let* ((imagen (nth (random 5) *imagenes*))
                           (json (format nil "{\"imagen_url\":\"~a\",\"estado\":\"ok\"}" imagen))
                           (response (format nil "HTTP/1.1 200 OK~c~cContent-Type: application/json~c~c~c~c~a" 
                                       #\Return #\Linefeed #\Return #\Linefeed #\Return #\Linefeed json)))
                        (usocket:socket-send socket response nil)))))))

(start-server)
