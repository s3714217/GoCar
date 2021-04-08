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
import java.util.List;



@TestMethodOrder(OrderAnnotation.class) 
public class editcar {
	
		
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
			chromeWebElement.sendKeys("admin@gocar.com");
			expectedResult = "Welcome admin@gocar.com";
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"password\"]"));
			chromeWebElement.sendKeys("qwerty");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"login\"]"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"user\"]"));
			actualResult = chromeWebElement.getText();
			assertEquals(expectedResult, actualResult);
			
			
		}
		
		@Test
		@Order(3)
		public void carpage() {
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"sidebarMenu\"]/ul/li[3]/a"));
			chromeWebElement.click();
			
			expectedResult = "Car Management | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
		}
		
		@Test
		@Order(4)
		public void caredit() {
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"carTable\"]/tr[1]/td[5]"));
			chromeWebElement.click();
			
			
		    Select dropdown = new Select(driver.findElement(By.xpath("//*[@id=\"updateLocation\"]")));
			dropdown.selectByVisibleText("376 Flinders St, Melbourne VIC 3000");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"addCarButton\"]"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"carTable\"]/tr[1]/td[2]"));
			actualResult = chromeWebElement.getText();
			expectedResult = "376 Flinders St, Melbourne VIC 3000";
		}
		
		@Test
		@Order(5)
		public void deletecar() {
								
			WebElement chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[2]/div/div/table/tr[1]/td[5]/button[2]"));
			chromeWebElement.click();
		
			
				
		}
			
		
		
	
		
		
}
		