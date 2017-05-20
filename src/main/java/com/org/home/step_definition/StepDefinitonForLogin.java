package com.org.home.step_definition;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

public class StepDefinitonForLogin {
	WebDriver driver;
	@Given("^Open firefox and start application$")
	public void open_firefox_and_start_application() throws Throwable {
	    // Write code here that turns the phrase above into concrete actions
		System.setProperty("webdriver.chrome.driver", "C:\\LatestSeleniumDrivers\\chromedriver.exe");
		driver=new ChromeDriver();
		driver.manage().window().maximize();
		driver.get("http://www.facebook.com");
	}

	@When("^I enter valid \"(.*?)\" and valid \"(.*?)\"$")
	public void i_enter_valid_and_valid(String uname, String pass) throws Throwable {
	    // Write code here that turns the phrase above into concrete actions
		driver.findElement(By.id("email")).sendKeys(uname.trim());
		driver.findElement(By.id("pass")).sendKeys(pass.trim());
	}

	@Then("^user should be able to login successfully$")
	public void user_should_be_able_to_login_successfully() throws Throwable {
	    // Write code here that turns the phrase above into concrete actions
		driver.findElement(By.id("loginbutton")).click();
	}

	@Then("^application should be closed$")
	public void application_should_be_closed() throws Throwable {
	    // Write code here that turns the phrase above into concrete actions
		WebElement homeLink;
		WebElement activityLink;
		//homeLink= driver.findElement(By.cssSelector("f_click"));
		/*homeLink=driver.findElement(By.linkText(""));//add your home link text
		homeLink.click();
		
		activityLink=driver.findElement(By.linkText("Friends"));
		activityLink.click();*/
		driver.quit();
	}
	
}
