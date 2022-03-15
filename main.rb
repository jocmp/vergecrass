#!/usr/bin/env ruby

require "nokogiri"
require "net/http"
require "date"

def main
  year_months = generate_year_months

  year_months.each do |year_month|
    year, month = year_month

    puts "Starting #{year}/#{month}"

    html_result = visit_page("https://www.theverge.com/archives/the-vergecast/#{year}/#{month}")

    anchors = html_result.search(".c-compact-river__entry .c-entry-box--compact__title a")

    anchors.each do |element|
      html = visit_page(anchor_url(element))
      download_podcast(html)
    end
  end
end

def download_podcast(page)
  with_output(page) do
    url = anchor_url(page.at('a:contains("Download MP3")'))

    next if !url

    uri = URI(url)

    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new(uri)

      title = friendly_title(page)

      open "output/#{title}.html", "w" do |io|
        io.write(page.css("article").to_xhtml)
      end

      http.request request do |response|
        open "output/#{title}.mp3", "w" do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end
  end
end

# https://stackoverflow.com/questions/15557652/create-a-range-of-months-between-two-dates-in-ruby
def generate_year_months
  start_date = Date.new(2011, 4)
  end_date = Date.new(2015, 1)

  current_month = start_date

  date_tuples = []

  while current_month <= end_date
    date_tuples << [current_month.year, current_month.month]
    current_month = current_month.next_month
  end

  date_tuples
end

def visit_page(url)
  result = Net::HTTP.get(URI(url))
  Nokogiri::HTML.parse(result)
end

def anchor_url(element)
  return if !element
  element.attributes["href"].value
end

def friendly_title(page)
  page
    .title
    .gsub(":", " ")
    .gsub("/", "-")
end

def with_output(page)
  puts "🦔 Starting #{page.title}"
  url = yield

  if !url
    puts "❌ Skipped #{page.title}"
  else
    puts "✅ Saved #{page.title}"
  end
end

if __FILE__ == $0
  main
end
