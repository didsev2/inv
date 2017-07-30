      # <table>
    #   <% @id = 0 %>
    #   <% @file.each_line do |line| %>
    #
    #   <tr>
    #     <td align = "right"><%= @id %></td>
    #     <td><%= @file_name[0,3] %></td>
    #     <td><%= line.split[0] %><br></td>
    #     <% @id += 1 %>
    #   </tr>
    #  <% end %> -->
    # </table> -->
    #
    #
    # <% nill_str = "000000" %> -->
    # <% nill_str[(5-(@id.to_s.length)+1),@id.to_s.length] = @id.to_s %> -->
    # FileTest::exist?("001.TXT")
