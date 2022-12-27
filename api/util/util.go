package util

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"

	"github.com/gorilla/mux"
)

func Must(value interface{}, err error) interface{} {
	if err != nil {
		log.New(os.Stderr, "Fatal: util.Must (intermediary): ", log.LstdFlags|log.Lshortfile).Fatalln(err)
	}
	return value
}

func WarnFactory(logger *log.Logger) func(interface{}, error) interface{} {
	return func(value interface{}, err error) interface{} {
		if err != nil {
			logger.Println(err.Error())
		}
		return value
	}
}

func Keys[K comparable, V any](m map[K]V) []K {
	keys := make([]K, 0)

	for k, _ := range m {
		keys = append(keys, k)
	}

	return keys
}

func Values[K comparable, V any](m map[K]V) []V {
	if m == nil {
		return nil
	}

	values := make([]V, 0)

	for _, v := range m {
		values = append(values, v)
	}

	return values
}

func ContainsValue[K comparable, V comparable](m map[K]V, value V) bool {
	if m == nil {
		return false
	}
	for _, v := range m {
		if v == value {
			return true
		}
	}
	return false
}

func ContainsKey[K comparable, V any](m map[K]V, key K) bool {
	if m == nil {
		return false
	}
	for k, _ := range m {
		if k == key {
			return true
		}
	}
	return false
}

func MapSlice[FromType any, ToType any](s []FromType, mapper func(FromType) ToType) (t []ToType) {
	for _, element := range s {
		t = append(t, mapper(element))
	}
	return
}

func RandomIntExclude(min, max int, blacklist []int) int {
	blacklistMap := make(map[int]bool)
	for _, v := range blacklist {
		blacklistMap[v] = true
	}
	for {
		n := min + rand.Intn(max+1)
		if blacklistMap[n] {
			continue
		}
		return n
	}
}

func MarshalNullableString(s sql.NullString) any {
	if !s.Valid {
		return nil
	}
	return s.String
}

func UnmarshalNullableString(v any) sql.NullString {
	if v == nil {
		return sql.NullString{}
	}
	return sql.NullString{Valid: true, String: v.(string)}
}

func NullableString(v string) sql.NullString {
	if v == "" {
		return sql.NullString{}
	}
	return sql.NullString{Valid: true, String: v}
}

func HttpBasicJsonError(res http.ResponseWriter, code int, reason ...string) {
	r := ""
	if len(reason) > 0 {
		r = fmt.Sprintf(`,"reason":"%s"`, reason[0])
	}
	http.Error(res, fmt.Sprintf(`{"error":{"status":"%s"%s}}`, http.StatusText(code), r), code)
}

func HttpBasicJsonResponse(res http.ResponseWriter, code int, value any) error {
	res.WriteHeader(code)
	return json.NewEncoder(res).Encode(value)
}

type Sitemap struct {
	Router  *mux.Router
	Sitemap map[*json.RawMessage]http.Handler
}

func (self *Sitemap) AddHandler(method, path string, handler http.HandlerFunc) *Sitemap {
	m := json.RawMessage(fmt.Sprintf(`{"method":"%s","path":"%s"}`, method, path))
	(*self).Sitemap[&m] = self.Router.Handle(path, handler).Methods(method).GetHandler()
	return self
}

var ErrNotImplemented error = fmt.Errorf("error: not (yet) implemented")
