defmodule DGUWeb.TruncationTest do
  use ExUnit.Case
  alias DGUWeb.Util.Truncation, as: T

  @long """
    An archive of historic contract data from the Business Link Contracts Finder website that closed in February 2015. The
    archive includes public sector contract tenders and contracts awarded between 11/2/2011 and 25/2/2015. The archive was
    superseded by a new Contracts Finder designed and operated by the Crown Commercial Service:
    https://www.gov.uk/contracts-finder This archive has been provided by the data.gov.uk team using data from the Crown
    Commercial Service. The data behind the Contracts Finder Archive is provided as a complete database dump (in SQLite3
    format), including all the contracts (notices) and awards. It excludes the Word documents and other attachments to the notices
  """

  @vlong_no_punc """
    An archive of historic contract data from the Business Link Contracts Finder website that closed in February 2015
    and The archive includes public sector contract tenders and contracts awarded between 11/2/2011 and 25/2/2015 The archive
    was superseded by a new Contracts Finder designed and operated by the Crown Commercial Service:
    https://www.gov.uk/contracts-finder This archive has been provided by the data.gov.uk team using data from the Crown
    Commercial Service. The data behind the Contracts Finder Archive is provided as a complete database dump (in SQLite3
    format), including all the contracts (notices) and awards. It excludes the Word documents and other attachments to the notices
  """

  @lots_of_text "An archive of historic contract data from the Business Link Contracts Finder website that closed in February 2015 and The archive includes public sector contract tenders and contracts awarded between 11/2/2011 and 25/2/2015 The archive was superseded by a new Contracts Finder designed and operated by the Crown Commercial Service:"

  test "doesn't truncate when unnecessary" do
    assert T.truncate("A small sentence") == "A small sentence"
  end

  test "returns first sentence" do
    assert T.truncate(@long) == "An archive of historic contract data from the Business Link Contracts Finder website that closed in February 2015"
  end

  test "finds a newline" do
    assert T.truncate(@vlong_no_punc) == "An archive of historic contract data from the Business Link Contracts Finder website that closed in February 2015"
  end

  test "ellipsis if nothing else" do
    res = T.truncate(@lots_of_text)

    assert String.length(res) == 140
    assert res == """
    An archive of historic contract data from the Business Link Contracts Finder website that closed in February 2015 and The archive include...
    """ |> String.strip
  end

end
