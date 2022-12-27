package meridian

import (
	"errors"
	"fmt"
	"net/http"
)

type ReportingHandlerFunc func(res http.ResponseWriter, req *http.Request) error
type ReportingErrorHandlerFunc func(err error, res http.ResponseWriter, req *http.Request)
type ReportingSuccessHandlerFunc func(res http.ResponseWriter, req *http.Request)

var Ok error = fmt.Errorf("ok")

func Reporter(handler ReportingHandlerFunc, errorHandler ReportingErrorHandlerFunc, successHandler ReportingSuccessHandlerFunc) http.HandlerFunc {
	return func(res http.ResponseWriter, req *http.Request) {
		err := handler(res, req)
		if err != nil {
			if errors.Is(err, Ok) {
				successHandler(res, req)
			} else {
				errorHandler(err, res, req)
			}
		}
	}
}
