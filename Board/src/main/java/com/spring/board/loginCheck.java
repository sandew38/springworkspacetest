package com.spring.board;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import com.spring.member.model.MemberVO;

import oracle.net.aso.l;

/* === 주업무(<예:글쓰기, 글수정, 댓글쓰기 등등>를 실행하기 앞서 
		이러한 주업무들은 먼저 로그인을 해야만 사용가능한 작업이므로  
		주업무에 대한 보조업무 객체로 로그인 여부를 체크하는 관심 클래스(객체)를 생성하여 
		포인트컷과 더불어 어드바이스를 생성하여 동작하도록 만든다.       */


/*	=== #81. 공통 관심사 클래스(Aspect 클래스) 생성하기*/
@Aspect
/* 공통관심사 클래스 객체로 등록한다.
- 기존의 XML <aop:aspect> 역할을 한다. */
@Component
/* XML에서 빈을 만드는 대신에 클래스명 앞에 @Component 어노테이션을 적어주면 해당 클래스는 bean으로 자동 등록된다. 
그리고 bean의 이름(첫글자는 소문자)은 해당 클래스명이 된다. */

public class loginCheck {

	// Pointcut을 생성한다.
	// - 아래의 메소드가 기존의 XML <aop:pointcut> 역할을 한다.
	// - void + 인자값 없음으로 선언한다. 
	// - 선언해도 어차피 어노테이션의 AspectJ 표현식이 우선이기 때문에 메소드 자체의 형식은 의미가 없다.
	// - 또한 구현부도 의미없다.
	// - 대신 메소드 이름이 나중에 각각의 Advice에서 식별자로 사용됨

	
	@Pointcut("execution(public * com.spring.board.BoardController.requireLogin_*(..))")
	public void requireLogin() { 
		
		
		
	}// end of public void requireLogin() ----
	
	
	// 보조업무 추가
	// -- 글쓰기, 글수정, 글삭제, 댓글쓰기 전 로그인 여부를 검사하는 Before Adivce를 생성한다.  
	
	@Before("requireLogin()")
	public void before(JoinPoint joinPoint) {
		
		/*
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		String now = sdf.format(new Date());
		
		System.out.println("===> 작성 날짜시간 : " + now);
		*/
		
		// 로그인 유무를 확인하기 위해서 request를 통해서 session을 얻어온다.
		HttpServletRequest request = (HttpServletRequest)joinPoint.getArgs()[0];
		HttpServletResponse response = (HttpServletResponse)joinPoint.getArgs()[1];
		
		HttpSession session = request.getSession();
		
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
//		System.out.println("로그인 유저 ID : " + loginuser.getUserid() );
		
		if( loginuser == null )
		{	// 로그인 안한 상태
			
			try
			{
				String result = "로그인이 필요합니다!";
				String loc = "/board/login.action";
				
				request.setAttribute("result", result);
				request.setAttribute("loc", loc);
				
				RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/viewsnotiles/msg.jsp");
				dispatcher.forward(request, response);
			}
			catch(ServletException e)
			{
				e.printStackTrace();
			} 
			catch (IOException e)
			{
				e.printStackTrace();
			}// end of try ~ catch ----
			
			
			// >>>> 로그인 후 로그인 하기전 페이지로 돌아가는 작업 하기 <<<<
			// ===>>> 현재 페이지의 주소(URL) 알아내기 <<<=== //			
			String url = request.getRequestURL().toString();
			// 현재 페이지의 URL은 getRequestURL()을 이용해서 구한다.
			
			/* 
			     그런데 URL에 쿼리문자열이 섞여서 Get방식으로 값이 넘어온 페이지라면 
			   getRequestURL() 메소드는 쿼리문자열(? 부터 시작하는 것)을 잘라버리고 출력하게 된다. 
			     즉 아래의 쿼리문자열(?page=1&seq=10) 부분은 getRequestURL() 메소드로는 잡히지 않는다는 뜻이다.
			   http://localhost/board.action?page=1&seq=10
			   
			   Get방식으로 넘어온 쿼리문자열을 구하기 위한 request 객체의 메소드는 getQueryString() 이다. 
			     이 getQueryString() 메소드는 쿼리문자열이 없을때는 null을 리턴해준다.  
            */
			
			Boolean bool_addComment = url.endsWith("addComment.action");
			// 댓글쓰기를 할 경우
			
			Boolean bool_download = url.endsWith("download.action");
	        // 파일 받기를 할 경우

			
			if(bool_addComment) 
			{
				url = url.replaceAll("addComment.action", "view.action");  
				// 로그인 후 글목록보기 페이지로 이동 하도록 한다.
			}
			else if (bool_download)
			{
				url = url.replaceAll("download.action", "view.action");
			}
			
			
			
			if(!bool_addComment && request.getQueryString() != null ) {
				// 댓글쓰기가 아니면서 쿼리문이 있는 경우
				url += "?" + request.getQueryString();	
			}
			else if(bool_addComment && request.getQueryString() != null ) {
				// 댓글쓰기이면서 쿼리문이 있는 경우
				String queryString = request.getQueryString();
				int index = queryString.indexOf("parentSeq=");
				String seqno = queryString.substring(index+"parentSeq=".length(), queryString.length());
				
				url += "?seq=" + seqno;	
			}
			
//			System.out.println(" >>> 확인용 현재 페이지 URL : " + url);
			
			session.setAttribute("url", url); // 세션에 url 정보를 저장시켜둔다.
			
			
		} // end of if ----
		
	}// end of before()--------------------
	
	
	
	
	
} // end of public class loginCheck ----
