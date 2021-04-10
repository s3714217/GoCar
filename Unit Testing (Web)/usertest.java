package gocar;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;
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
public class usertest {
	
		
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
		public void Login() {
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"username\"]"));
			chromeWebElement.clear();
			chromeWebElement.sendKeys("admin_master@gocar.com");
			expectedResult = "Welcome admin_master@gocar.com";
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"password\"]"));
			chromeWebElement.sendKeys("12345678");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"login\"]"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"user\"]"));
			actualResult = chromeWebElement.getText();
			assertEquals(expectedResult, actualResult);
			
			
		}
		
		@Test
		@Order(3)
		public void userpage() {
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"sidebarMenu\"]/ul/li[5]/a"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[2]/div/div/table/tr[1]/td[3]/button[1]"));
			chromeWebElement.click();
			
			expectedResult = "User Central | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
			
			
		
		}
		
		@Test
		@Order(4)
		public void userdetail() {
			WebElement chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[2]/div/div/table/tr[1]/td[3]/button[2]"));
			chromeWebElement.click();
			
			expectedResult = "View User Management | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
		}
		
	
		@Test
		@Order(6)
		public void veriftytest() {
			
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"sidebarMenu\"]/ul/li[5]/a"));
			chromeWebElement.click();
			
			driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS); 
			
		    chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[2]/div/div/table/tr[1]/td[2]"));
			actualResult = chromeWebElement.getText();     
			
			expectedResult = "verified";
			assertEquals(expectedResult, actualResult);
			
		}
		
		@Test
		@Order(7)
		public void deletetest() {
			
			
			WebElement chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[2]/div/div/table/tr[2]/td[3]/button[3]"));
			chromeWebElement.click();
			
			
		}
	
	
		
		
		
		

	@AfterAll
		
		public static void close() {
		
		}
	
		
}
