<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- JDBC 프로그램으로 DB데이터를 가져와서 화면 출력 --%>
<%
	//JDBC 프로그램을 위한 변수 선언
	final String DRIVER = "oracle.jdbc.OracleDriver";
	final String URL = "jdbc:oracle:thin:@localhost:1521:xe";
	final String USER = "mystudy";
	final String PASSWORD = "mystudypw";
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	//사용할 SQL 쿼리 작성
	String sql = ""
		+ "SELECT ROWNUM AS RN, SABUN, NAME, NALJA, PAY "
		+ "  FROM GUEST"
		+ " ORDER BY SABUN";
	int cnt = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체목록</title>
</head>
<body>
	<h1>전체목록</h1>
	<table border>
		<thead>
			<tr>
				<th>번호</th>
				<th>사번</th>
				<th>성명</th>
				<th>날짜</th>
				<th>금액</th>
				<th>상세보기</th>
			</tr>
		</thead>
		<tbody>
		<%-- 
			<tr>
				<td>1</td>
				<td>1111</td>
				<td>USER1</td>
				<td>2021/05/29</td>
				<td>1000</td>
				<td>상세보기</td>
			</tr>
		--%>
<%
	try {
		//1. JDBC 드라이버 로딩
		Class.forName("oracle.jdbc.OracleDriver");
		
		//2. DB연결  - Connection 객체 생성 <-DriverManager
		conn = DriverManager.getConnection(
				"jdbc:oracle:thin:@localhost:1521:xe", 
				"mystudy", "mystudypw");
		
		//3. Statement문 실행(SQL문 실행)
		//3-1. Connection 객체로 부터 PreparedStatement 객체 생성
		pstmt = conn.prepareStatement(sql);
		
		//4. 쿼리 실행
		rs = pstmt.executeQuery();
		while (rs.next()) { %>
			<%--ROWNUM AS RN, SABUN, NAME, NALJA, PAY --%>
			<tr>
				<td><%=rs.getInt("RN")%></td>
				<td><%=rs.getInt("SABUN") %></td>
				<td><%=rs.getString("NAME") %></td>
				<td><%=rs.getDate("NALJA") %></td>
				<td><%=rs.getInt("PAY") %></td>
				<td>
					<a href="detail.jsp?idx=<%=rs.getInt("SABUN") %>">상세정보</a>
				</td>
			</tr>
<%
		} //end while
		rs.close();
		
		//전체 데이터 건수 확인
		rs = pstmt.executeQuery("SELECT COUNT(*) AS CNT FROM GUEST");
		if (rs.next()) {
			cnt = rs.getInt("CNT");
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		//5. 클로징 처리에 의한 자원 반납
		try {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
	}
%>				
		</tbody>
	</table>
	<p>전체인원 : <%=cnt %></p>
	<p><a href="addForm.jsp">사원등록</a></p>
</body>
</html>



