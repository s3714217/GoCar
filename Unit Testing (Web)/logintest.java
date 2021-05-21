package gocar;

import static org.junit.jupiter.api.Assertions.*;

import java.util.concurrent.TimeUnit;

import org.junit.Before;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import org.junit.jupiter.api.TestInstance.Lifecycle;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;




@TestMethodOrder(OrderAnnotation.class) 
public class logintest {
	
		
		private static ChromeDriver driver;
		private String expectedResult;
		private String actualResult;
	

		@BeforeAll

		public static void setup() {
			System.setProperty("Webdriver.chrome.driver", "chromedriver.exe");
			
			driver = new ChromeDriver();

		}
		
		
		@Test
		@Order(1)
		public void website() {

			driver.get("https://gocarrmit.ts.r.appspot.com/");
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
		
			expectedResult = "Login | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
		

		}
		
		@Test
		@Order(2)
		public void NoPassword() {
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"username\"]"));
			chromeWebElement.sendKeys("admin_master@gocar.com");
			expectedResult = "Please enter a password";
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"login\"]"));
			chromeWebElement.click();
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"passwordEmpty\"]"));
			
			actualResult = chromeWebElement.getText();
			assertEquals(expectedResult, actualResult);
			
			
		}
		
		@Test
		@Order(3)
		public void Login() {
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"username\"]"));
			chromeWebElement.clear();
			chromeWebElement.sendKeys("admin_master@gocar.com");
			expectedResult = "Welcome admin_master@gocar.com";
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"password\"]"));
			chromeWebElement.sendKeys("MASTERpassword1@");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"login\"]"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"user\"]"));
			actualResult = chromeWebElement.getText();
			assertEquals(expectedResult, actualResult);
			
			
		}
		
		@Test
		@Order(4)
		public void Logout() {
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"sidebarMenu\"]/ul/li[7]/a"));
			chromeWebElement.click();
			
			expectedResult = "Login | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
		}
		
		
		
		

	@AfterAll
		
		public static void close() {
		driver.close();
			
		}
	
		
}
