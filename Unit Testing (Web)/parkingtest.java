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
public class parkingtest {
	
		
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
			chromeWebElement.sendKeys("MASTERpassword1@");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"login\"]"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"user\"]"));
			actualResult = chromeWebElement.getText();
			assertEquals(expectedResult, actualResult);
			
			
		}
		
		@Test
		@Order(3)
		public void parkingpage() {
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"sidebarMenu\"]/ul/li[4]/a"));
			chromeWebElement.click();
			
			
			expectedResult = "Parking Management | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
			
			
		
		}
		
		@Test
		@Order(4)
		public void list() {
			
			
			//No.of rows 
			List<WebElement>  rows = driver.findElements(By.xpath("//*[@id=\"locationsTable\"]/tr/td[1]")); 
			System.out.println("No of rows are : " + rows.size());
        
			int expectedsize = 65;
			int tablesize = rows.size();
			assertEquals(expectedsize, tablesize);
		
	}
		
		
		
		
		@Test
		@Order(5)
		public void addparkingpage() {
			
			WebElement chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[1]/div[2]/button"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"parkingAddress\"]"));
			Wait wait = new WebDriverWait(driver, 10);
		    wait.until(ExpectedConditions.visibilityOf(chromeWebElement));
			
			chromeWebElement.sendKeys("State Route 55, Docklands VIC 3008");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"parkingLatitude\"]"));
			chromeWebElement.sendKeys("-37.8149");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"parkingLongitude\"]"));
			chromeWebElement.sendKeys("144.9505");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"addParkingButton\"]"));
			chromeWebElement.click();
		}
			
		
		
		@Test
		@Order(6) 
			public void deleteparking() {
				
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"sidebarMenu\"]/ul/li[4]/a"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[2]/div/div/table/tr[23]/td[4]"));
			chromeWebElement.click();
			
			
			}
		
		
		
		

	@AfterAll
		
		public static void close() {
		
		}
	
		
}
