require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open"https://learn-co-curriculum.github.io/student-scraper-test-page/index.html")
    students = []
    index_page.search("div.roster-cards-container").each do |profile|
      profile.search(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.search(".student-location").text
        student_name = student.search(".student-name").text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    # binding.pry
    links = profile_page.search(".social-icon-container").children.search("a").collect {|element| element.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("youtube")
        student[:youtube] = link
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] = profile_page.search(".profile-quote").text if profile_page.search(".profile-quote")
    student[:bio] = profile_page.search("div.bio-content.content-holder div.description-holder").text.strip if profile_page.search("div.bio-content.content-holder div.description-holder")
    student  
  end
end

