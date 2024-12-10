import { Box } from '@chakra-ui/react';
import ColumnsTable from 'views/admin/dataTables/components/ColumnsTable';
import React from 'react';

export default function Settings() {
  const [cakeData, setTableData] = React.useState([]);
  const [cakeColumns, setTableColumns] = React.useState([]);

  React.useEffect(() => {
    async function fetchCakeData() {
      const response = await fetch('http://localhost:3000/cake/getAll');
      const data = await response.json();

      const columns = Object.keys(data.result[0]).map((key) => ({
        Header: key,
        accessor: key,
      }));

      console.log(columns);
      console.log(data.result);

      setTableColumns(columns);
      setTableData(data.result);
    }

    fetchCakeData();
  }, []);

  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      <ColumnsTable columnsData={cakeColumns} tableData={cakeData} tableName={'Cakes'} />
    </Box>
  );
}