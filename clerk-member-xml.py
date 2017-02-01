import requests
import shutil
from xml.dom.minidom import parseString
import datetime
from pathlib import Path

def run():
    response = requests.get("http://clerk.house.gov/xml/lists/MemberData.xml")

    with open("cache/latest.xml", 'w') as out_file:
        out_file.write(response.text)

    parsed_xml = parseString(response.content)

    publish_date = parsed_xml.getElementsByTagName("MemberData")[0].getAttribute("publish-date")
    publish_date = datetime.datetime.strptime(publish_date, "%B %d, %Y").strftime("%Y%m%d")
    
    #see if cache exists
    filepath = "cache/MemberData.{}.xml".format(publish_date)
    thefile = Path(filepath)
    if not thefile.is_file():
        print("saved to {}".format(filepath))
        output = parsed_xml.toprettyxml(indent = "  ")
        with open(filepath, 'w') as out_file:
            out_file.write(output)

    print("done")

if __name__ == "__main__":
    run()