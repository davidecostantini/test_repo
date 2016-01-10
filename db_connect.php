<html>
  <head>
   <title>Test</title>
  </head>
  <body bgcolor="white">

  <?php
  $link = pg_Connect("host=localhost dbname=taskize user=flynn password=test_password");
  $result = pg_exec($link, "select * from taskize");
  $numrows = pg_numrows($result);
  echo "<p>link = $link<br>
  result = $result<br>
  numrows = $numrows</p>
  ";
  ?>

  <table border="1">
  <tr>
   <th>ID</th>
   <th>Fruit</th>
  </tr>
  <?php

   for($ri = 0; $ri < $numrows; $ri++) {
    echo "<tr>\n";
    $row = pg_fetch_array($result, $ri);
    echo " <td>", $row["id"], "</td>
   <td>", $row["col2"], "</td>
  </tr>
  ";
   }
   pg_close($link);
  ?>
  </table>
  </body>
  </html>

