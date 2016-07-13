# require 'rubygems'
# require 'mechanize'
# require 'watir-nokogiri'
# require 'pry'

module RucomServices

  class Scraper
    PAGE_URL = 'http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf'

    attr_accessor :rucom_page, :data_to_find, :clic_selector

    def initialize(page = nil, data = {}, clic_selector = nil)
      self.rucom_page = page || PAGE_URL
      self.data_to_find = data
      self.clic_selector = clic_selector
    end

    def call
      driver = Selenium::WebDriver.for :phantomjs
      driver.navigate.to PAGE_URL
      driver.execute_script("$(\"[id='form:trol_panel']\").css('display', 'block')")
      # panel = driver.find_element(id: 'form:trol_panel')
      option = driver.find_element(:xpath => "//*[@data-label='Barequero']")
      option.click
      sleep 2
      buttom = driver.find_element(id: 'form:consultar')
      buttom.click
      driver.quit
    end

  end
end