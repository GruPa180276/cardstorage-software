// 22/07/07, J. Mayrhofer
//
// Automatically calculate the hours spent on the project by parsing
// the documentation for a given date/time format.

// todo:
// [ ] filter meta data using json format in begin tag
// [x] deal with leap hours (eg 23:00 - 01:30)

package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"strings"
	"time"
)

func must(val interface{}, err error) interface{} {
	if err != nil {
		log.Fatalln(err)
	}
	return val
}

// Beware! Arguments are unchecked and are interpreted either as regular expression or file paths!

func main() {
	if len(os.Args) < 3 {
		log.Fatalln("Usage:", os.Args[0], "<regexp for hours>", "<files to process>")
	}

	var pattern_begin *regexp.Regexp = regexp.MustCompile(`<!-- { "progress": true.* } -->`)
	var pattern_end *regexp.Regexp = regexp.MustCompile(`<!-- { "progress": false } -->`)

	var hours []string

	for _, file := range os.Args[2:] {
		hours = append(hours, string(must(ioutil.ReadFile(file)).([]byte)))
	}

	var sum float64 = 0
	const time_fmt string = "15:04"

	for _, hour := range hours {
		begin, end := pattern_begin.FindIndex([]byte(hour)), pattern_end.FindIndex([]byte(hour))
		for _, line := range strings.Split(strings.TrimSpace(hour[begin[1]:end[0]]), "\n") {
			var entry []string = regexp.MustCompile(`\d{1,2}:\d{1,2}`).FindAllString(line, 2)
			var begin time.Time = must(time.Parse(time_fmt, entry[0])).(time.Time)
			var end time.Time = must(time.Parse(time_fmt, entry[1])).(time.Time)

			// in case it got late again ;)
			if end.Hour() < begin.Hour() {
				end = end.Add(must(time.ParseDuration("24h")).(time.Duration))
			}

			fmt.Println(entry)

			sum += end.Sub(begin).Hours()
		}
	}

	fmt.Printf("\n%dh %.2fmin\n", int(sum), (sum-float64(int(sum)))*60)
}
