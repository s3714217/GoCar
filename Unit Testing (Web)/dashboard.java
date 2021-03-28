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
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.Wait;
import org.openqa.selenium.support.ui.WebDriverWait;




@TestMethodOrder(OrderAnnotation.class) 
public class dashboard {
	
		
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
		
		
		
		

		}
		
		@Test
		@Order(2)
		public void Login() {
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"username\"]"));
			chromeWebElement.clear();
			chromeWebElement.sendKeys("admin@gocar.com");
		
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"password\"]"));
			chromeWebElement.sendKeys("qwerty");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"login\"]"));
			chromeWebElement.click();
			
		
		
			
			
		}
		
		@Test
		@Order(3)
		public void totalusers() {
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"countUsers\"]"));
			
			
			Wait wait = new WebDriverWait(driver, 10);
		    wait.until(ExpectedConditions.visibilityOf(chromeWebElement));

		    actualResult = chromeWebElement.getText();
		    expectedResult = "24";
			assertEquals(expectedResult, actualResult);
		}
		
		@Test
		@Order(4)
		public void totalcars() {
			
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"countCars\"]"));
			actualResult = chromeWebElement.getText();
			expectedResult = "39";
			assertEquals(expectedResult, actualResult);
			
			
		}
		
		@Test
		@Order(5)
		public void totalparking() {
			
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"countParkings\"]"));
			actualResult = chromeWebElement.getText();
			expectedResult = "20";
			assertEquals(expectedResult, actualResult);
		}
		
		
		
		

	@AfterAll
		
		public static void close() {
		driver.close();
			
		}
	
		
}
