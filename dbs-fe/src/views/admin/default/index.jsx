/*!
  _   _  ___  ____  ___ ________  _   _   _   _ ___   
 | | | |/ _ \|  _ \|_ _|__  / _ \| \ | | | | | |_ _| 
 | |_| | | | | |_) || |  / / | | |  \| | | | | || | 
 |  _  | |_| |  _ < | | / /| |_| | |\  | | |_| || |
 |_| |_|\___/|_| \_\___/____\___/|_| \_|  \___/|___|
                                                                                                                                                                                                                                                                                                                                       
=========================================================
* Horizon UI - v1.1.0
=========================================================

* Product Page: https://www.horizon-ui.com/
* Copyright 2023 Horizon UI (https://www.horizon-ui.com/)

* Designed and Coded by Simmmple

=========================================================

* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

*/

// Chakra imports
import {
  Avatar,
  Box,
  Flex,
  FormLabel,
  Icon,
  Select,
  SimpleGrid,
  Table,
  useColorModeValue,
  Th,
  Tbody,
  Thead,
  Tr,
  Td,
} from '@chakra-ui/react';
// Assets
import Usa from 'assets/img/dashboards/usa.png';
import { Tab } from 'bootstrap';
// Custom components
import MiniCalendar from 'components/calendar/MiniCalendar';
import MiniStatistics from 'components/card/MiniStatistics';
import IconBox from 'components/icons/IconBox';
import React from 'react';
import {
  MdAddTask,
  MdAttachMoney,
  MdBarChart,
  MdFileCopy,
} from 'react-icons/md';
import CheckTable from 'views/admin/default/components/CheckTable';
import ComplexTable from 'views/admin/default/components/ComplexTable';
import DailyTraffic from 'views/admin/default/components/DailyTraffic';
import PieCard from 'views/admin/default/components/PieCard';
import Tasks from 'views/admin/default/components/Tasks';
import TotalSpent from 'views/admin/default/components/TotalSpent';
import WeeklyRevenue from 'views/admin/default/components/WeeklyRevenue';
import {
  columnsDataCheck,
  columnsDataComplex,
} from 'views/admin/default/variables/columnsData';
import tableDataCheck from 'views/admin/default/variables/tableDataCheck.json';
import tableDataComplex from 'views/admin/default/variables/tableDataComplex.json';

export default function UserReports() {
  // Chakra Color Mode
  const brandColor = useColorModeValue('brand.500', 'white');
  const boxBg = useColorModeValue('secondaryGray.300', 'whiteAlpha.100');

  const [topCakeData, setTopCakeData] = React.useState([]);

  React.useEffect(() => {
    const fetchTopCakeData = async () => {
      // http://localhost:3000/cake/getTopCake?startDate=2024-01-01&endDate=2024-12-31&top=10&search=Bánh&filterQuantity=3
      const response = await fetch(
        `http://localhost:3001/cake/getTopCake?startDate=2024-01-01&endDate=2024-12-31&top=10`,
      );

      const data = await response.json();
      console.log('data: ', data);
      setTopCakeData(data);
    };

    fetchTopCakeData();
  }, []);

  const [topCusData, setTopCusData] = React.useState([]);

  React.useEffect(() => {
    const fetchTopCusData = async () => {
      // http://localhost:3000/customer/top5-spenders?startDate=YYYY-MM-DD(isNull)&endDate=YYYY-MM-DD(isNull)
      const response = await fetch(
        `http://localhost:3001/customer/top5-spenders?startDate=2024-01-01&endDate=2024-12-31`,
      );

      const data = await response.json();
      console.log('data: ', data);
      setTopCusData(data);
    };

    console.log('topCusData: ', topCusData);
    fetchTopCusData();
  }, []);

  const [cakeImportPrice, setCakeImportPrice] = React.useState([]);

  React.useEffect(() => {
    const fetchCakeImportPrice = async () => {
      // http://localhost:3000/cake/getCakeImportPrice
      const response = await fetch(
        `http://localhost:3001/cake/getTotalImportPrice?` + new URLSearchParams({minPrice: 0}),
      );

      const data = await response.json();
      console.log('data: ', data);
      setCakeImportPrice(data);
    };

    fetchCakeImportPrice();
  }, [])


  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      <SimpleGrid
        columns={{ base: 1, md: 2, lg: 2, '2xl': 6 }}
        gap="20px"
        mb="20px"
      >
        <label>Top bánh bán chạy của năm (Procedure)</label>
        <Table>
          <Thead>
            <Tr>
              <Td>STT</Td>
              {/* <Td>ID</Td> */}
              <Td>Tên</Td>
              <Td>Số lượng</Td>
            </Tr>
          </Thead>
          <Tbody>
            {topCakeData.map((cake, index) => (
              <Tr key={cake.id}>
                <Td>{index + 1}</Td>
                {/* <Td>{cake.CakeID}</Td> */}
                <Td>{cake.Name}</Td>
                <Td>{cake.TotalQuantity}</Td>
              </Tr>
            ))}
          </Tbody>
        </Table>

        {/* {
    "CustomerPhone": "0842000111",
    "CustomerName": "Hoan Vu Khai",
    "TotalMoneySpent": 400000
} */}
        <label>Top khách hàng của năm (Function)</label>
        <Table>
          <Thead>
            <Tr>
              <Td>STT</Td>
              <Td>Số điện thoại</Td>
              <Td>Tên</Td>
              <Td>Số tiền đã mua</Td>
            </Tr>
          </Thead>
          <Tbody>
            {topCusData.map((customer, index) => (
              <Tr key={customer.id}>
                <Td>{index + 1}</Td>
                <Td>{customer.CustomerPhone}</Td>
                <Td>{customer.CustomerName}</Td>
                <Td>{customer.TotalMoneySpent}</Td>
              </Tr>
            ))}
          </Tbody>
        </Table>

        {/* {
    "CakeName": "Salty Cake A",
    "TotalImportPrice": 254000
} */}
        <label>Giá nguyên liệu nhập bánh (Procedure)</label>
        <Table>
          <Thead>
            <Tr>
              <Td>STT</Td>
              <Td>Tên</Td>
              <Td>Tổng giá nguyên liệu</Td>
            </Tr>
          </Thead>
          <Tbody>
            {cakeImportPrice.map((cake, index) => (
              <Tr key={cake.id}>
                <Td>{index + 1}</Td>
                <Td>{cake.CakeName}</Td>
                <Td>{cake.TotalImportPrice}</Td>
              </Tr>
            ))}
          </Tbody>
        </Table>
      </SimpleGrid>
    </Box>
  );
}
