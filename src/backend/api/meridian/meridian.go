package meridian

import (
	"encoding/json"
	"net/http"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type ReportingHandlerFunc func(res http.ResponseWriter, req *http.Request) (error, *Ok)
type ReportingErrorHandlerFunc func(onError error, res http.ResponseWriter, req *http.Request)
type ReportingSuccessHandlerFunc func(onSuccess *Ok, res http.ResponseWriter, req *http.Request)

type Ok struct {
	Message string
	ToJson  bool
}

func Okay(message ...string) *Ok {
	m := ""
	if len(message) > 0 {
		m = message[0]
	}
	return &Ok{Message: m, ToJson: true}
}

func OkayMustJson(message any) *Ok {
	return &Ok{Message: string(util.Must(json.Marshal(message)).([]byte)), ToJson: false}
}

func (self *Ok) Jsonify(flag bool) *Ok {
	self.ToJson = flag
	return self
}

func (self *Ok) Error() string {
	return self.Message
}

func HttpReporter(handler ReportingHandlerFunc, errorHandler ReportingErrorHandlerFunc, successHandler ReportingSuccessHandlerFunc) http.HandlerFunc {
	return func(res http.ResponseWriter, req *http.Request) {
		err, success := handler(res, req)
		if err != nil {
			errorHandler(err, res, req)
		}
		// only call successHandler if there was no error err
		// and success message exists
		if success != nil && err == nil {
			successHandler(success, res, req)
		}
	}
}

type StaticHttpReporter struct {
	ErrorHandler   ReportingErrorHandlerFunc
	SuccessHandler ReportingSuccessHandlerFunc
}

func (self *StaticHttpReporter) Reporter(handler ReportingHandlerFunc) http.HandlerFunc {
	return HttpReporter(handler, self.ErrorHandler, self.SuccessHandler)
}

type MqttReporterFunc func(mqtt.Message) (error, *Ok)
type MqttReporterErrorHandlerFunc func(error, mqtt.Message)
type MqttReporterSuccessHandlerFunc func(*Ok, mqtt.Message)

func MqttReporter(handler MqttReporterFunc, errorHandler MqttReporterErrorHandlerFunc, successHandler MqttReporterSuccessHandlerFunc) func(mqtt.Message) {
	return func(message mqtt.Message) {
		err, success := handler(message)
		if err != nil {
			errorHandler(err, message)
		}
		// only call successHandler if there was no error err
		// and success message exists
		if success != nil && err == nil {
			successHandler(success, message)
		}
	}
}

type StaticMqttReporter struct {
	MqttReporterErrorHandlerFunc
	MqttReporterSuccessHandlerFunc
}

func (self *StaticMqttReporter) Reporter(handler MqttReporterFunc) func(mqtt.Message) {
	return MqttReporter(handler, self.MqttReporterErrorHandlerFunc, self.MqttReporterSuccessHandlerFunc)
}
