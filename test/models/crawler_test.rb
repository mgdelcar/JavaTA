require 'test_helper'

class CrawlerTest < ActiveSupport::TestCase

  def test_parse_table
    html_table = '
<table class="calltable highlightrowonhover sorttable zebrastripe overalllayoutalignblock">
  <thead>
    <tr>
      <th>#</th>
      <th>Category</th>
      <th>Problem</th>
      <th>Date/Time</th>
    </tr>
  </thead>
  <tbody>
    <tr style="white-space: nowrap;">
      <td>
        1
      </td>
      <td>
        BJP3 Chapter 1
      </td>
      <td>
        BJP3 Self-Check 1.01: binaryNumbers
      </td>
      <td>
        2014-09-06
        11:56:09
      </td>
    </tr>
    <tr style="white-space: nowrap;">
      <td>
        2
      </td>
      <td>
        BJP3 Chapter 1
      </td>
      <td>
        BJP3 Self-Check 1.10: Shaq
      </td>
      <td>
        2014-09-06
        12:14:05
      </td>
    </tr>
    <tr style="white-space: nowrap;">
      <td>
        3
      </td>
      <td>
        BJP3 Chapter 1
      </td>
      <td>
        BJP3 Self-Check 1.11: downwardSpiral
      </td>
      <td>
        2014-09-06
        12:19:58
      </td>
    </tr>
    <tr style="white-space: nowrap;">
      <td>
        4
      </td>
      <td>
        BJP3 Chapter 4
      </td>
      <td>
        BJP3 Self-Check 4.02: logicExpressions1
      </td>
      <td>
        2014-10-30
        20:54:30
      </td>
    </tr>
  </tbody>
  <tfoot/>
</table>'

    result = Crawler.extract_grades(html_table)

    assert_equal(4, result.count)
    assert(!result['BJP3 Self-Check 1.1'].nil?, "'BJP3 Self-Check 1.1' should be a key")
    assert(!result['BJP3 Self-Check 4.2'].nil?, "'BJP3 Self-Check 4.2' should be a key")
  end

  def test_parse_grades
    file = File.open(File.join(File.dirname(__FILE__), 'sample_html.html'), 'rb')
    html_page = file.read

    result = Crawler.extract_grades(html_page)
    
    assert_equal(11, result.count)
  end

  def test_extract_problem_key
    problem_name = 'BJP3 Self-Check 1.04: cookieRecipe'

    key = Crawler.extract_problem_key(problem_name)

    assert_equal('BJP3 Self-Check 1.4', key)
  end

end
