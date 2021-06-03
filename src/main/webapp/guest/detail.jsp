<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 전달받은 사번으로 DB에서 조회해서 가져온 데이터 화면 표시 --%>
<%
	//1. 전달받은 값 추출
	String idx = request.getParameter("idx");

	//2. DB데이터 조회(idx : 사번)
	final String DRIVER = "oracle.jdbc.OracleDriver";
	final String URL = "jdbc:oracle:thin:@localhost:1521:xe";
	final String USER = "mystudy";
	final String PASSWORD = "mystudypw";
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	//DB데이터 저장용 변수 선언
	int sabun = 0;
	String name = "";
	Date nalja = null;
	int pay = 0;
	
	try {
		//1. JDBC 드라이버 로딩
		Class.forName("oracle.jdbc.OracleDriver");
		
		//2. DB연결  - Connection 객체 생성 <-DriverManager
		conn = DriverManager.getConnection(
				"jdbc:oracle:thin:@localhost:1521:xe", 
				"mystudy", "mystudypw");
		
		//3. Statement문 실행(SQL문 실행)
		//3-1. Connection 객체로 부터 PreparedStatement 객체 생성
		//사용할 SQL 쿼리 작성
		String sql = ""
			+ "SELECT SABUN, NAME, NALJA, PAY "
			+ "  FROM GUEST "
			+ " WHERE SABUN = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, Integer.parseInt(idx));
		
		//4. 쿼리 실행
		rs = pstmt.executeQuery();
		if (rs.next()) { 
			sabun = rs.getInt("SABUN");
			name = rs.getString("NAME");
			nalja = rs.getDate("NALJA");
			pay = rs.getInt("PAY");
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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세페이지</title>
</head>
<body>
	<h1>상세정보</h1>
	<table>
		<tr>
			<th>사번</th>
			<td><%=sabun %></td>
		</tr>
		<tr>
			<th>성명</th>
			<td><%=name %></td>
		</tr>
		<tr>
			<th>날짜</th>
			<td><%=nalja %></td>
		</tr>
		<tr>
			<th>금액</th>
			<td><%=pay %></td>
		</tr>
	</table>
	<a href="editForm.jsp?idx=<%=sabun %>&name=<%=URLEncoder.encode(name, "UTF-8")%>&pay=<%=pay%>">수정</a>
	<a href="delete.jsp?idx=<%=sabun %>">삭제</a>
</body>
</html>









