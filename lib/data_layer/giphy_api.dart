import 'dart:convert';
import 'package:http/http.dart';
import '../utils.dart';

class GiphyAPI {
  static const apiKey = "fEUZJc4SRxjMh6VBPLt552tAuQRfnsRF";
  static const String endpointURL = "api.giphy.com/v1/gifs";

  static Future<GiphyAPIResponse> getGIF(int numberOfAttempts) async {
    int statusCode = 0;
    int counter = 0;
    String gifId = "";

    while ((statusCode > 300 || statusCode < 200) && counter <= 3) {
      counter += 1;
      gifId = GifsList.randomGif(numberOfAttempts);
      final response =
          await get(Uri.parse('https://$endpointURL/$gifId?api_key=$apiKey'));
      statusCode = response.statusCode;
      if (statusCode == 200) {
        return GiphyAPIResponse.fromJSON(jsonDecode(response.body));
      }
    }

    return GiphyAPIResponse.empty();
  }
}

class GiphyAPIResponse {
  final int status;
  final String? originalWEBP;
  final String? originalURL;
  final String? defaultURL;

  GiphyAPIResponse(
      this.status, this.originalWEBP, this.originalURL, this.defaultURL);

  factory GiphyAPIResponse.fromJSON(Map<String, dynamic> apiResponse) {
    String? originalWebpTemp = "";
    String? originalURLTemp = "";
    Map<String, dynamic> apiData = apiResponse['data'];

    if (apiData.containsKey("images")) {
      if (apiData['images'].containsKey("original")) {
        if (apiData['images']['original'].containsKey("webp")) {
          originalWebpTemp = apiData['images']['original']['webp'];
        }
        if (apiData['images']['original'].containsKey("url")) {
          originalURLTemp = apiData['images']['original']['url'];
        }
      }
    }

    return GiphyAPIResponse(apiResponse['meta']['status'], originalWebpTemp,
        originalURLTemp, apiData['url']);
  }

  factory GiphyAPIResponse.empty() {
    return GiphyAPIResponse(300, null, null, "");
  }

  String gifURL() {
    if (status >= 300) return "";
    return originalWEBP ?? originalURL ?? defaultURL ?? "";
  }
}

class GifsList {
  static const List<String> _notFound = [
    "26ybwvTX4DTkwst6U",
    "3orif0hbdBk2TxIFkQ",
    "xT5LMXCiTmWhTjFg1W",
    "18ANhgTABn04M",
    "3o6MbdLRnar1cXh8Pu",
    "3ohuAxV0DfcLTxVh6w",
    "B08TdBNGhwSNv7aS5r",
    "YTJXDIivNMPuNSMgc0",
    "26tP3M3i03hoIYL6M",
    "KHJw9NRFDMom487qyo",
    "Jk4ZT6R0OEUoM",
    "EXHHMS9caoxAA",
    "EimNpKJpihLY4",
    "ux9RhvE4hY1XOhQRF7",
    "Uun3HIZM8KSz69jhJt",
    "Xe2vSY5Q42KbkSCkqZ",
    "HKch5zpaH97ck",
    "0H9f6UfRoHHpUjgp2Q",
    "3BWJO4cqGYVbaQH3UU",
    "3ePb1CHEjfSRhn6r3c",
    "7OfNbBQHgxYVG",
    "tZpGRRMUoXgeQ",
    "YXyxtg0oyzDP2",
    "KYNywoibU1PQ4",
    "NxEsKrLJXPuwg",
    "12f8yqmdsi0L9S",
    "iqNM7CwedNaSY",
    "MC8hMWWQ8wgtW",
    "xUNd9MUxuzQD6kc44o",
    "ZbYlHbFxNPS8TXIm8q",
    "vyTnNTrs3wqQ0UIvwE",
    "spfi6nabVuq5y",
    "wYyTHMm50f4Dm",
    "i1JSXl0MfeRd6",
    "hEH8ATUeaaI12",
    "d2Z4NRCUxsxZBvag",
    "NpL4D3Oc2bJUMAXF9P",
    "kGW5m5CpzaIH5FIiYv",
    "WIpC2876R8bofSTdgs",
    "usUm1EU5N5CBG",
    "JtLrtaN4VPoKXJRKGB",
    "tiZ6sYY0VfSNO",
    "1rJnNRTAgCk0w",
    "LRxdnngiG8PPW",
    "DlDc6NYZvVcw8",
    "8NQ7T1ExRuMz6",
    "3o85xziIp4uruHAtB6",
    "26tPnXTr2f78OJrQ4",
    "3kryvnL4MJVPQEQ622",
    "Y8hzdgPnZ6Hwk",
    "8NeR1BbpwJqLv0dqFU",
    "uvMBNCgvzzl2I1JkTc",
    "j4b3GvKct3HBC"
  ];
  static const List<String> _foundIn5 = [
    "TNO6mwK8s38vpHjh8Y",
    "MNmyTin5qt5LSXirxd",
    "vgUFOWBwBkziE",
    "ffJ6aDa3WnglqxiLRN",
    "jtirFYtVwG5a0o1t9o",
    "10Jpr9KSaXLchW",
    "11ZAUfeJHojWlW",
    "UAXK9VGoJTbdcPgmcJ",
    "l2YWykMPCmCb9lLWM",
    "11ISwbgCxEzMyY",
    "oBPOP48aQpIxq",
    "11KzAJHqRIbfwY",
    "3oEdv3Ul8g6BCngQ36",
    "6CYXe7Hf8FZyU",
    "26FPnsRww5DbqoPuM",
    "pNpONEEg3pLIQ",
    "fa4E839VTHoFJZ02Mo",
    "JEVRfQblU1XbjaYf7g",
    "XtifHDS6IOZa3Ewu2U",
  ];
  static const List<String> _foundIn4 = [
    "zbytLwRaaSNjey4DPy",
    "yw4puYW748gDhBvk1j",
    "3ohzdIuqJoo8QdKlnW",
    "fkD36jhiqzJ9m",
    "5VMNcCxVBibZK",
    "12PhfWZDEgVbXi",
    "4T48716LEWUGA",
    "31lPv5L3aIvTi",
    "S24vAZeES2INy",
    "w0MYyUAvYCS64",
    "VS1OZuOgiuR68",
    "ynRrAHj5SWAu8RA002",
    "XwGVf8gQqt5rG",
    "S51cPgf254I06sJxA3",
    "k6iq3IZ8qGKIlCM6R8",
    "6CYXe7Hf8FZyU",
    "3oFzlUq9gpFanxX1f2",
    "26BRBKqUiq586bRVm",
    "wZjlCH43M3M0U",
    "VqFhKBifawzIc",
    "OcZp0maz6ALok",
    "sBLcw5Ic4QUTK",
    "oVjKPgSf93rJ2GE6Jm",
    "5p2wQFyu8GsFO",
  ];
  static const List<String> _foundIn3 = [
    "k0hKRTq5l9HByWNP1j",
    "uLiEXaouJVkuA",
    "1nb7b8KrLNtEf8jAM9",
    "i79P9wUfnmPyo",
    "NbXTwsoD7hvag",
    "nGzeO4uSxRUcg",
    "zyin7TYoGmLAs",
    "q4sdF9tchap6E",
    "Mdsrh9MUxmAPS",
    "g5zvwUa9720pO",
    "RTfIwAFTKf9HDOI0cL",
    "ummeQH0c3jdm2o3Olp",
    "eIqt0Yd3vgfXG",
    "3o7TKMJCgdpxM2Fgd2",
    "a9imQoghMq5IQ",
    "ZU9QbQtuI4Xcc",
    "l3q2XhfQ8oCkm1Ts4",
    "9DMlt1KUBQnJe",
    "byR4lWlXhCG36QUx9W",
    "2EWZGiLI2NqIo",
    "8i7IQbqY4iXuD3MDRT",
    "KzM1lAfJjCWNq",
    "oYtVHSxngR3lC",
    "GGMUpbtiNX4C4",
  ];
  static const List<String> _foundIn2 = [
    "Od0QRnzwRBYmDU3eEO",
    "DffShiJ47fPqM",
    "ihBQKvIE7gLEA",
    "tlGD7PDy1w8fK",
    "hjvinhl1pUrb1gdzlV",
    "RRAnrYj7r8XHh2N5qH",
    "lkK7hFTOp1s4g",
    "xTiN0CNHgoRf1Ha7CM",
    "CI6hQq7NgmCqI",
    "ZcRHy8MT94liDNhfTs",
    "3o85xr9ZKY1wbbJXDW",
    "Wrv5v6egIh7Ww",
    "y8Mz1yj13s3kI",
    "f9Rrghj6TDckb5nZZR",
    "AVBo5eqFXd3SU",
    "xT77XWum9yH7zNkFW0",
    "OluyzCAatv35C",
    "1L5YuA6wpKkNO",
  ];
  static const List<String> _foundIn1 = [
    "9oF7EAvaFUOEU",
    "9PMC8BD8b2AaA",
    "tu11NwAPEuIRhTlDXA",
    "woPJ4I9nDVvL7s3fMv",
    "26ufbuylgBBc8lQBy",
    "bb0Xwo6UoHTPy",
    "v12FFFTON0WgE",
    "26ufdipQqU2lhNA4g",
    "l3q2SaisWTeZnV9wk",
    "h2OLfcSKKthRK",
  ];

  static String randomGif(int numberOfAttempts) {
    switch (numberOfAttempts) {
      case 1:
        return pickRandomElementFromList(_foundIn1);
      case 2:
        return pickRandomElementFromList(_foundIn2);
      case 3:
        return pickRandomElementFromList(_foundIn3);
      case 4:
        return pickRandomElementFromList(_foundIn4);
      case 5:
        return pickRandomElementFromList(_foundIn5);
      default:
        return pickRandomElementFromList(_notFound);
    }
  }
}
